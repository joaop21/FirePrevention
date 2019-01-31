/*********************************************
 * OPL 12.8.0.0 Model
 * Author: MDIOMasters
 * Creation Date: 05/12/2018 at 12:13:33
 *********************************************/
// Parâmetros
int n = ...;
int m = n*n;
int cNorte [1..n] [1..n] = ...; 
int cOeste [1..n] [1..n] = ...; 
int cSul [1..n] [1..n] = ...; 
int cEste [1..n] [1..n] = ...; 
int custo[1..m][1..m];

// variável de decisão: tempo que o fogo demora a chegar à célula i
dvar int y[1..m];

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
maximize sum(i in 2..m) y[i]; // ou começa em 1?? // se começar em 1 nao influencia pq é 0 na soma
subject to{
// para o primeiro nodo -> tempo = 0
y[1]==0;
// para os restantes nodos
forall (i in 1..m,j in 1..m) y[j]-y[i]<=custo[i][j];
forall(i in 1..m) y[i]>=0;
}