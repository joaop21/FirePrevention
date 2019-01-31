/*********************************************
 * OPL 12.8.0.0 Model
 * Author: MDIOMasters
 * Creation Date: 27/11/2018 at 23:12:49
 *********************************************/

// Parâmetros
int n = ...;
int m = n*n;
int cNorte [1..n] [1..n] = ...; 
int cOeste [1..n] [1..n] = ...; 
int cSul [1..n] [1..n] = ...; 
int cEste [1..n] [1..n] = ...; 
int custo[1..m][1..m];

// variável de decisão: nº de caminhos de que faz parte o arco ij
dvar int x[1..m][1..m];

// povoar a matriz de custos 49x49
execute{

	for(var a = 1; a <= m; a++){ // a é o nodo de origem
	
		for(var b = 1; b <= m; b++)	{ // b é o nodo de destino
		
			var div = Opl.ceil(a/n);
			var res = a%n;
			
			if(res == 0) res = n;
			
			if((a-b) == n && div!=1) custo[a][b] = cNorte[div][res];
			
			else if((b-a) == n && div!=n) custo[a][b] = cSul[div][res];
			
			else if((b-a) == 1 && res!=n) custo[a][b] = cEste[div][res];
			
			else if((a-b) == 1 && res!=1) custo[a][b] = cOeste[div][res];
			
			else custo[a][b] = 1000000;
			
		}
	}
}

// Função objetivo
minimize sum(i in 1..m, j in 1..m) custo[i][j]*x[i][j];
subject to{
// não existem arcos para o próprio nodo
forall (i in 1..m) d1: (x[i][i] == 0);
// para o primeiro nodo
d4: (sum(j in 1..m) (x[1][j] - x[j][1])) == m-1;
// para os restantes nodos
forall (i in 2..m) d2: (sum (j in 1..m)  (x[i][j] - x[j][i])) == -1;
// controlo
forall(i in 1..m, j in 1..m) d3: (x[i][j]>=0);
}