#include <stdio.h>

char name[99];

int main(void) {
  printf('What is your name? ');
  scanf("%s", name);
  printf('Hello %s!', name);

return 0;
}
