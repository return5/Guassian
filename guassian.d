import std.stdio; //input and output
import std.uni; //isAlpha()
import std.algorithm;  //reverse()
import std.conv; //to!double()
import std.string; //split()

/*
   program which implements a simple gaussian elimination on a matrix.
   written in D to help learn the language. 
   limited to numbers, either ints or floating point. doesnt handle trig expressions, complex numbers, nor laplace.
   input must be limited to numbers and whitespaces. no '+','-','=' nor any other symbol or letter.
   author: github.com/return5
 */

//solves for the variable of the given row. end is the index for the variable to solve for.
double solveForX(const double [] matrix_row,const double [] solutions, const int end) {
	double sum = matrix_row[matrix_row.length-1];
	int j = 0;
	for(int i = cast(int)matrix_row.length - 2; i > end; i--) {
			sum -= matrix_row[i] * solutions[j++];
	}
	return sum/matrix_row[end];
}

//returns matrix which contains the values for the variables of the equation.
double [] getSolutions(const double [][] matrix) {
	double [] solutions;
	for(int i = cast(int) matrix.length-1; i >= 0; i--) {
			solutions ~= solveForX(matrix[i],solutions,i);
	}
	return solutions;
}

//subtracts row above start_row row from all rows below it.  
double [][] subLinesTogether(double [][] matrix,const int start_column, const int start_row) {
	for(int i = start_row; i < matrix.length; i++){
		matrix[i][start_column .. matrix[i].length] -= matrix[start_row - 1][start_column .. matrix[i].length];
	}
	return matrix;
}

//divides through each row by the number in the location of 'index' in order to get that number to be 1.
double [][] divideThrough(double [][] matrix, const int start_row, const int index) {
	for(int i = start_row; i < matrix.length; i++) {
		if(matrix[i][index] != 0) {
			matrix[i][] /= matrix[i][index];
		}
	}
	return matrix;
}

//checks to make sure matrix is correct size.
int checkMatrixSize(const double [][] matrix) {
	for(int i = 0; i < matrix.length; i++) {
		if(matrix.length != matrix[i].length-1) {
			writeln("your matrix must be square. try again");
			return 0;
		}
	}
	return 1;
}

//makes sure there are only numbers and spaces in a row.
int checkIfAlpha(const string row) {
	foreach(c;row) {
		if(isAlpha(c)) {
			return 0;
		}
	}
	return 1;
}

//gets user to unput the matrix one row at a time.can only be numbers or whitespaces.
double [][] getMatrix() {
	double [][] matrix;
	string line;	
	do {
		writeln("please enter an equation of numbers.type \"done\" when finished.");
		line = strip(readln());
		if (line == "done") {
			break;
		}
		else if (line == "") {
			writeln("sorry, line cannot be empy");	
		}
		else if (checkIfAlpha(line) == 0) {
			writeln("sorry, rows must only contain numbers and spaces");
		}
		else {
			matrix ~= to!(double[])(split(line));
		}
	} while (line != "done" );
	return matrix;
}

void main() {
	double [][] matrix = getMatrix();
	double [] solutions;
	if(checkMatrixSize(matrix) == 1 ) {	
		for (int i = 0; i < matrix[0].length-2; i++) {
			matrix = divideThrough(matrix,i,i);	
			matrix = subLinesTogether(matrix,i,i+1);
		}
		solutions = getSolutions(matrix); 
		reverse(solutions);
	}
	writeln("matrix in row eschelon form is :", matrix);
	writeln("solution matrix is :", solutions);
}
