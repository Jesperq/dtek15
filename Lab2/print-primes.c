/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6

//prints number n
void print_number(int n){
	static int counter = 0;	
	
	printf("%10d ", n);
	
	counter++;
	if(counter % COLUMNS == 0){
		printf("\n");
	}
}

void print_primes(int n){
	
	int i;
	for(i = 2; i < n; i++){
		if(is_prime(i)){
			print_number(i);
		}
	}

	printf("\n");

}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
	if(argc == 2)
		print_primes(atoi(argv[1]));
	else
		printf("Please state an interger number.\n");
	return 0;
}



/*
is_prime
By Rickard Larsson
Returns 1 if n is a prime, and 0 if it is not.
*/
int is_prime(int n){
	// starta på 2, eftersom allt är delbart med 1
	int i;
	for (i = 2; i < n; i++) {
		// om n är perfekt delbart med i, och i inte är lika med n är n inte ett primtal
		if (n % i == 0) {
			return 0;
		}
	}
	return 1;
}












