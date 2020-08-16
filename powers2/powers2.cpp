#include <iostream>
#include <cmath>
#include <fstream>
#include <string>
using namespace std;

int main(int argc, char **argv){
	int i,bits,n,n_dupl,k,counterOne,inputs;
	ifstream infile(argv[1]);
	infile >> inputs;                            // read first line of txt to know how many lines we're reading	
	
	for(int line=0; line<inputs; line++)         // for loop for reading every line in txt file
	{
		//initializations.
		infile >> n >> k;
		counterOne = 0;
		bits = floor(log(n)/log(2)) + 1;
		int binary[bits];
		n_dupl = n;
		
		
		for(i=0; n_dupl>0; i++)                    // for loop to make the number n in its binary form
		{    
			binary[i] = n_dupl%2;    
			n_dupl = n_dupl/2;
			if(binary[i]==1)
				counterOne++;
		}
		
		if(k>n || k<counterOne) cout<<"[]"<<endl;   // if these statements are true, the certain couple(n,k) cant be solved
		else{
			while(counterOne != k){                   // while counterOne is not k then 
				for(int i=1;i<bits;i++){                // we need to search how many elements in i position 
					if(binary[i]!= 0){                    // can be represented as elements in i-1 position
						binary[i]-=1;                       // for this reason we subtract one from i-th element and 
						binary[i-1]+=2;                     // add 2 in i-1 element. 
						counterOne++;                       // And add one in the counter that keeps track of how many 1 we used.
						break;
					}
				}
			}
			// Printing the output.
			for(i=0;counterOne!=0;i++)    
			{   
				if( i == 0){
					cout << "["<<binary[i];
					counterOne-=binary[i];
					if(counterOne == 0 ) cout<<"]"<<endl;
					else cout<<",";	
				} 
				else if (counterOne-binary[i] == 0){
					cout <<binary[i]<<"]"<<endl;
					counterOne-=binary[i];	
	
				} 
				else{
					cout << binary[i]<<",";
					counterOne-=binary[i];
				}				  
			}
		}		
	}	   
}	  


