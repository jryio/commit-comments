// This is a normal comment 
#include <iostream>
#include <string>

using namespace std;

int main () {
 
  // The following is a "commit-comment"  
  // @commit: Stored Hello World in stringw
  string phrase = "Hello World!";
  cout << phrase  << endl;

  int a = 10; // @commit - Inline commit comment
  int b = 33; /* @commit ... Another inline commit comment */
  int c = 90; /*** @commit: final inline commit comment ***/

  // Invalids comment syntax

  / @commit: Something
  / @ commit A space
  @commit no comment
  @commitnospaces
  @commit@commit: double commit symbols
}
