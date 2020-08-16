#include <iostream>
#include <fstream>
#include <list>
#include <algorithm>
using namespace std;

/*GLOBAL DECLARATIONS OF LISTS*/
#define MAX	1000001
list<int> adjList[MAX];
int len[MAX];
/*END OF GLOBAL DECLARATIONS OF LISTS*/

/*Using N lists to represent adjacency list
  list numbering starting from 1 to N+1*/

/*function to add edges in the adjacency list*/
void addEdge(list<int> *adjList, int u, int v){ 
    adjList[u].push_back(v); 
    adjList[v].push_back(u); 
}

/*Finding all nodes that have only one edge.Removing the edge u-v.
Way to find this edge is by searching which list has size equal to
one. When found, pop element v from list[u] and search in list[v]
for element u and remove it. Also after removing u from list[v] 
check list[v] size if it is equal to one, to repeat process.*/

void cutEdge_Auxilary(int u, list<int> *adjList, int *len, int &cycles){
	int remove = adjList[u].front();
	adjList[u].pop_front();		 
    len[remove] = len[remove] + len[u];
	len[u] = 0;
	cycles--;
	adjList[remove].remove(u);
	if(adjList[remove].size() == 1){cutEdge_Auxilary(remove,adjList,len,cycles);}
} 

void cutEdge(list<int> *adjList, int V, int *len, int &cycles){  
    for (int u=1; u<=V; u++)
		if (adjList[u].size() == 1)	cutEdge_Auxilary(u, adjList,len,cycles);
        
}
/*end of cutEdge and cutEdge_Auxilary*/

/*Functions connected and connectedAux find if the graph is connected*/

void connectedAux(int v, bool *visited, list<int> *adjList){ 
	
    visited[v] = true;
    for (list<int>::iterator i = adjList[v].begin(); i != adjList[v].end(); ++i) 
        if (!visited[*i]) connectedAux(*i, visited, adjList); 
} 

bool connected(int v, list<int> *adjList){  
    bool *visited = new bool[v+1]; 
    for (int i = 1; i <= v; i++) 
        visited[i] = false; 

    connectedAux(v, visited, adjList);
        
    for(int i = 1; i <= v; i++){
    	if(visited[i]) continue;
    	else return false;
	}
	return true;
} 
/*end of connected and connectedAux*/

int main(int argc, char **argv){
	int n,m,numberOfGraphs,u,v,cycles;
	
	ifstream infile(argv[1]);
	infile >> numberOfGraphs;
	for(int i=0; i <numberOfGraphs; i++){
		
		for (int j = 1; j<= n;j++) adjList[j].clear();  // clear all lists one by one to get ready for next input.

		infile >> n >> m;
		
		bool corona = true;				
		for (int j=0 ; j<m ;j++){
			infile >> u >> v;
			addEdge(adjList, u, v);	
		}
		
		for(int i = 1; i<=n ; i++) len[i] = 1;   //initialisation of all nodes to have weight equal to 1.
		
		/* if graph is connected then it might be a coronagraph.
		Cycles variable is a counter of how many nodes are in 
		the cycle. Starting value is n, and when we call cutEdge
		each time we cut an edge we decrease its value by one.*/
		if(connected(n,adjList)){          
			cycles = n;				       
			cutEdge(adjList,n,len,cycles); 
			
			//to be a corona graph, then all its edges must have only 2 nodes connected to it, else its not.
			for(int i = 1; i<=n; i++){
				if(adjList[i].size() == 0 || adjList[i].size() == 2) continue;
				else {
					corona = false;
					break;
				}
			}
			
			/*if all other checks passed, then its corona. We sort the len array.
			Every line of that array has the number of nodes that tree has with 
			root node the number of line. Then do the printing.*/
			if(corona){
				sort(len+1,len+n+1);							
				cout<< "CORONA "<<cycles<<endl;
				for(int k = 1; k<=n; k++){
					if(len[k] == 0) continue;
					else{
						if(cycles == 1)	cout<<len[k]<<endl;
						
						else{
							cout<<len[k]<<" ";
							cycles--;	
						}
					}
				}
			}
			else cout<<"NO CORONA"<<endl;
		}
		else cout<<"NO CORONA"<<endl;
	}
	return 0;
}
