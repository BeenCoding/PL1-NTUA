import java.io.*;
import java.util.ArrayDeque;
import java.util.Queue;

// in order to save the states in the form we want (in a triplet which contains leftFlag,right,path), Triplet.java is created
// which helps us keep these info.

public class Vaccine {

    public static void main(String args[]) {
        try{
            String left,right,path,newRight,bestPath,tempPath;
            char savedCurLetter,curLetter;
            int curChCounter,leftFlag,childrenCounter = 1;
            Triplet<Integer,String,String> temp;
            Queue<Triplet<Integer,String,String>> s = new ArrayDeque<Triplet<Integer,String,String>>();
            
            File input = new File(args[0]);
            BufferedReader reader = new BufferedReader(new FileReader(input));
            int N = Integer.parseInt(reader.readLine());
            while((left = reader.readLine()) != null){                                                           // left every time is the string we check to find the path.
                childrenCounter = 1;                                                                             // always set to 1 so as the first time for stmt will run
                s.clear();                                                                                       // clear the queue where all states are
                s.add(new Triplet<Integer,String,String>(0, "", ""));                                            // initial state( s keeps (leftFlag,right,path))
                while(!left.isEmpty()){                                                                          // while there are letters in the string we read do
                    savedCurLetter = left.charAt(left.length()-1);                                               // current letter every time by cutting the rightmost character of string
                    left = left.substring(0, left.length() - 1);                                                 // cutting the letter from string
                    curChCounter = childrenCounter;                                                              // saving the childrens number so as we do the for curChCounter times
                    childrenCounter = 0;                                                                         // setting childrenCounter to zero, so as we count how many children will be born in this iteration

                    // the moves will be done with this order: cp,crp,p,rp so as we find the lexicographically smallest solution
                    // also when a move is done children's counter is increased by one, so as we now how many times for statement will run.

                    for(int i = 0; i < curChCounter; i++){
                        temp = s.remove();                                                                       // pop the leftmost element from the queue
                        leftFlag = temp.getFlag();                                                               // and gets its attributes(leftFlag,right,path)
                        right = temp.getRight();
                        path = temp.getPath();
                        if(leftFlag == 1)                                                                        // leftFlag let us know wether this element needs to be complement or not
                            curLetter = complement(savedCurLetter);
                        else 
                            curLetter = savedCurLetter;
                        
                        if(!right.isEmpty()){                                                                    // if right isnt empty then we can do this, else there is no reason to do
                            newRight = p(right,complement(curLetter));                                           // its an optimisation because they can never start from cp
                            if(valid(newRight)){
                                s.add(new Triplet<Integer,String,String>(1-leftFlag, newRight, path+"cp"));
                                childrenCounter++;
                            }
                        }
                        if(right.length() > 1){                                                                  // if length of right is greater than 1 we can proceed to crp move
                            newRight = p(new StringBuilder(right).reverse().toString(),complement(curLetter));   // else there is no reason cause reverse gives same result
                            if(valid(newRight)){
                                s.add(new Triplet<Integer,String,String>(1-leftFlag, newRight, path+"crp"));
                                childrenCounter++;
                            }
                        }
                        newRight = p(right, curLetter);                                                          // always do the p move
                        if(valid(newRight)){
                            s.add(new Triplet<Integer,String,String>(leftFlag, newRight, path+"p"));
                            childrenCounter++;
                        }
                        if(right.length() > 1){                                                                  // if length of right is greater than 1 we can proceed to rp move
                            newRight = p(new StringBuilder(right).reverse().toString(),curLetter);               // else there is no reason cause reverse gives same result
                            if(valid(newRight)){
                                s.add(new Triplet<Integer,String,String>(leftFlag, newRight, path+"rp"));
                                childrenCounter++;
                            }
                        }
                    }
                }

                // finding the best path. Setting the best path to be the first thing from the queue. So we remove the first element
                // and get the attribute that we need (which is path).
                temp = s.remove();
                bestPath = temp.getPath();
                // keeping the size of the s because it alters (because of the .remove())
                int s_size = s.size();
                for(int i = 0; i < s_size; i++){
                    temp = s.remove();
                    tempPath = temp.getPath();
                    // iterating through all s and checking wether the current bestpath has more length than the tempPath or 
                    // if they have same length BUT tempPath is smaller(lexicographically less) than bestpath.
                    if(tempPath.length() < bestPath.length() || (tempPath.length() == bestPath.length() && tempPath.compareTo(bestPath) < 0))
                        bestPath = tempPath;
                }
                System.out.println(bestPath);
            }
            reader.close();
        }
        catch(FileNotFoundException e){}
        catch(IOException e) {}
    }

    //function to validate the move that was made with p function. In this algorithm we keep only to the right stack
    //only the 4 letters(A,C,G,U). no dublicates. So the length cannot be greater than 4 or right be empty.
    //if the first check is passed then we need to check the first letter(top of stack) with all the others so as it 
    //is different. If equal then false. We do the same thing(same check) but starting from the end of the string and
    //checking it with all the others if different. If not then false. The reason we do this is because valid function
    //checks all moves(either is reversed or not).

    private static boolean valid(String right) {
        if(right.length() > 4 || right.isEmpty())
            return false;
        
            for (int i = 1; i < right.length(); i++)
                if(right.charAt(0) == right.charAt(i))
                    return false;
        
            for (int i = right.length()-2; i >= 0 ; i--)
                if(right.charAt(right.length()-1) == right.charAt(i))
                    return false;
                
        return true;
        
    }

    //function that makes the move. Gets right stack and the current letter.
    //if the right stack is empty just return the current letter.
    //else if the highest in stack is equal to the current letter that is going to be in stack return only the stack
    //else return the addition of current letter top of the stack

    private static String p(String right, char curLetter) {
        if(right.isEmpty()) 
            return String.valueOf(curLetter);
        else if (right.charAt(0) == curLetter)
            return right;
        else 
            return(curLetter + right);
    }

    //function to make the complements as the exercise says: A <--> U and G <--> C

    private static char complement(char cLet) {
        if(cLet == 'A') return('U');
        else if(cLet == 'U') return('A');
        else if(cLet == 'G') return('C');
        else if(cLet == 'C') return('G');
        else return 0;
    }
}