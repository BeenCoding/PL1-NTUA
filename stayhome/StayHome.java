   // ---------------------------------------//
  // javac StayHome.java  ---> compiling    //
 // java StayHome fileName ---> run        //
// ---------------------------------------//

import java.io.*;
import java.util.*;
import java.awt.Point;

public class StayHome {
    private static char[][] globe = new char[1000][1000];
    private static char[][] previous = new char[1000][1000];
    private static int N,M,activated = 0;
    private static boolean reached = false;
    private static Queue<Point> sotiris = new ArrayDeque<>();
    private static Queue<Point> airport = new ArrayDeque<>();
    private static Queue<Point> virus = new ArrayDeque<>();
    private static int t,finishingPx,finishingPy,startingPx,startingPy;

    public static void main(String args[]) {
        try{
            int ln = 0;
            String st;
            File input = new File(args[0]);
            BufferedReader reader = new BufferedReader(new FileReader(input));
            while((st = reader.readLine()) != null){
                globe[ln] = st.toCharArray();
                ln++;
            }
            reader.close();
            
            N = ln;
            M = globe[0].length;
            
            for(int i = 0; i<N; i++){
                for(int j = 0; j<M; j++){
                    if(globe[i][j] == 'A'){
                        airport.add(new Point(i,j));
                    }
                    if(globe[i][j] == 'S'){
                        sotiris.add(new Point(i,j));
                        startingPx = i;
                        startingPy = j;                        
                    }
                    if(globe[i][j] == 'W'){
                        virus.add(new Point(i,j));
                    }
                    if(globe[i][j] == 'T'){
                        finishingPx = i;
                        finishingPy = j;
                    }
                }
            }
            Point pointsV,pointsA,pointsS;
            char temp;
            int length_sotiris,length_airport,length_virus,cordX,cordY;
            while(!reached){
                if (t % 2 == 1){
                    length_virus = virus.size();
                    for(int k = 0; k < length_virus; k++){
                        pointsV = virus.remove();
                        cordX = pointsV.x;
                        cordY = pointsV.y;
                        spread(cordX,cordY);
                    }
                }
                
                if((activated >= 6) && (activated % 2 == 0) && (t % 2 == 0)){
                    length_airport = airport.size();
                    for(int k = 0; k < length_airport; k++){
                        pointsA = airport.remove();
                        cordX = pointsA.x;
                        cordY = pointsA.y;
                        if(globe[cordX][cordY] == 'A' || globe[cordX][cordY] == 'Z' || globe[cordX][cordY] == 'S'){
                            globe[cordX][cordY] = 'I';
                            airport.add(new Point(cordX,cordY));
                        }
                        else{
                            spread(cordX,cordY);
                        }
                        
                    }
                }
                length_sotiris = sotiris.size();
                for (int k = 0; k < length_sotiris; k++){
                    pointsS = sotiris.remove();
                    cordX = pointsS.x;
                    cordY = pointsS.y;
                    if(globe[cordX][cordY] != 'S' && globe[cordX][cordY] != 'Z'){
                        temp = globe[cordX][cordY];
                        globe[cordX][cordY] = 'S';
                        spread(cordX,cordY);
                        globe[cordX][cordY] = temp;
                    }
                    else{
                        spread(cordX,cordY);
                    }
                }
                
                if(activated > 0){
                    activated += 1;
                }
                
                t += 1;
            }
            System.out.println(t);

            final char[] path = new char[t];
            path[--t] = previous[finishingPx][finishingPy];

            while(finishingPx != startingPx || finishingPy != startingPy ){
                path[t] = previous[finishingPx][finishingPy];
                if(previous[finishingPx][finishingPy] == 'U')
                    finishingPx += 1;
                else if(previous[finishingPx][finishingPy] == 'D')
                    finishingPx -= 1;
                else if(previous[finishingPx][finishingPy] == 'L')
                    finishingPy += 1;
                else if (previous[finishingPx][finishingPy] == 'R')
                    finishingPy -= 1;
                
                t--;
            }
            String ans = new String(path);
            
            System.out.println(ans);

        }
        catch(FileNotFoundException e){}
        catch(IOException e) {}
    }

    private static void spread(int cordX, int cordY) {
        validMove(cordX+1,cordY,globe[cordX][cordY],'D');
        validMove(cordX,cordY-1,globe[cordX][cordY],'L');
        validMove(cordX,cordY+1,globe[cordX][cordY],'R');
        validMove(cordX-1,cordY,globe[cordX][cordY],'U');
        
    }

    private static void validMove(int cordX, int cordY, char idx, char move) {
        if ((cordX < 0) || (cordX >= N) || (cordY < 0) || (cordY >= M)) return;
        if (globe[cordX][cordY] == 'X') return;

        if (idx == 'S' || idx == 'Z'){
            if (globe[cordX][cordY] == 'T'){
                if (previous[cordX][cordY] == 0){
                    previous[cordX][cordY] = move;
                }
                else{
                    if (move > previous[cordX][cordY]){
                        previous[cordX][cordY] = move;
                    }
                }
                reached = true;
            }
            else if (globe[cordX][cordY] == '.'){
                globe[cordX][cordY] = 'S';
                previous[cordX][cordY] = move;
                sotiris.add(new Point(cordX,cordY));
            }
            else if (globe[cordX][cordY] == 'A'){
                globe[cordX][cordY] = 'Z';
                previous[cordX][cordY] = move;
                sotiris.add(new Point(cordX,cordY));
            }
            return;
        }
        if (idx == 'W'){
            if(globe[cordX][cordY] == 'T'){
                System.out.println("IMPOSSIBLE\n");
                System.exit(0);
            }
            else if (globe[cordX][cordY] == 'S' || globe[cordX][cordY] == '.'){
                globe[cordX][cordY] = 'W';
                virus.add(new Point(cordX,cordY));
                return;            
            }
            else if (globe[cordX][cordY] == 'Z' || globe[cordX][cordY] == 'A'){
                globe[cordX][cordY] = 'W';
                airport.remove(new Point(cordX, cordY));
                virus.add(new Point(cordX,cordY));
                activated = 1;
                return;
            }
        }
        if (idx == 'I'){
            if (globe[cordX][cordY] == 'T'){
                System.out.println("IMPOSSIBLE\n");
                System.exit(0);
            }
            else if (globe[cordX][cordY] == 'S' || globe[cordX][cordY] == '.'){
                globe[cordX][cordY] = 'I';
                airport.add(new Point(cordX,cordY));
            }
            return;
        }
    }
}