	for(i = 2; i < n; i++) {
		// om talet vi �r p� �r ett primtal, skriv ut det
		if(is_prime(i)) {
			print_number(i);
		}
	}
	// Skriv ut ny rad p� slutet
	printf("\n");
	return 0;
}

// print numbers with 10 spaces between them, in COLUMNS number of columns
int print_number(int n) {
	// static = beh�ller variabeln under hela k�rningen, det nollst�lls inte
	static int counter = 0;

	printf("%10d", n);

	// kolla om vi ska skriva p� ny rad
	counter++;
	if(counter % COLUMNS == 0) {
		printf("\n");
	}
	return;
}

/*
is_prime
By Rickard Larsson
Returns 1 if n is a prime, and 0 if it is not.
*/
int is_prime(int n){
	// starta p� 2, eftersom allt �r delbart med 1
	int i;
	for (i = 2; i < n; i++) {
		// om n �r perfekt delbart med i, och i inte �r lika med n �r n inte ett primtal
		if (n % i == 0 && i != n) {
			return 0;
		}
	}
  return 1;
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_primes(atoi(argv[1]));
  else
	  print_primes(105);
    //printf("Please state an interger number.\n");
  return 0;
}