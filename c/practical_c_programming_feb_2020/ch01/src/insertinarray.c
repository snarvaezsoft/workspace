#include <stdio.h>

#define max 100




void main()
{

  int p[max], i, j, k, n;

  printf("Enter number of elements:");
  scanf("%d", &n);

  printf("Enter the elements:\n");
  for (i = 0; i < n; ++i) {
    scanf("%d", &p[i]);
  }

  printf("Enter the position where to insert:\n");
  scanf("%d", &k);

  k--;  /* because index base 0 */

  for (j = n-1; j>=k; --j) {
    p[j+1] = p[j];
  }

  n++;  /* There is one more element after insert */

  printf("Value to insert:");
  scanf("%d", &p[k]);

  printf("Array after insert:\n");
  for (i = 0; i < n; ++i) {
    printf("%d\n", p[i]);
  }


}
