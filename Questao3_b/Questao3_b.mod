/*********************************************
 * OPL 12.8.0.0 Model
 * Author: joao
 * Creation Date: 07/12/2018 at 17:11:35
 *********************************************/
 int n = ...;
int m = n*n;
int cNorte [1..n] [1..n] = ...; 
int cOeste [1..n] [1..n] = ...; 
int cSul [1..n] [1..n] = ...; 
int cEste [1..n] [1..n] = ...; 
int custo[1..m][1..m];
int intervalo=...;
int retardamento = ...;
float prob[1..m];
int recursos = ...;

//verifica se uma c�lula est� queimada ou n�o
dvar boolean x[1..m];
//verifica se uma c�lula est� protegida ou n�o
dvar boolean y[1..m];
// tempo que o fogo demora a chegar � c�lula i
dvar int t[1..m];


  execute{

	for(var a = 1; a <= m; a++){ // a é o nodo de origem
	
		for(var b = 1; b <= m; b++)	{ // b é o nodo de destino
		
			var div = Opl.ceil(a/n);
			var res = a%n;
			
			
			if(res == 0) res = n;
			prob[a]=(14-div-res)/500;
			
			if((a-b) == n && div!=1) custo[a][b] = cNorte[div][res];
			
			else if((b-a) == n && div!=n) custo[a][b] = cSul[div][res];
			
			else if((b-a) == 1 && res!=n) custo[a][b] = cEste[div][res];
			
			else if((a-b) == 1 && res!=1) custo[a][b] = cOeste[div][res];
			
			else custo[a][b] = 1000000;
			
		}
	}
}

//Fun��o objetivo
minimize sum (i in 1..m) (prob[i]*x[i]);

subject to {
t[1]==0;
forall(i in 1..m,j in 1..m) t[j]-t[i]<=custo[i][j]+retardamento*y[i];
sum (i in 1..m) y[i] <=recursos;
forall (i in 1..m) x[i] >= (intervalo-t[i])/intervalo;
}