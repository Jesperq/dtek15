/*
 prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>

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
		if (n % i == 0 && i != n) {
			return 0;
		}
	}
  return 1;
}

int main(void){
  printf("%d\n", is_prime(11));  // 11 is a prime.      Should print 1.
  printf("%d\n", is_prime(383)); // 383 is a prime.     Should print 1.
  printf("%d\n", is_prime(987)); // 987 is not a prime. Should print 0.
}