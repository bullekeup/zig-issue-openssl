#include <openssl/bn.h>
#include <stdio.h>

int main() {
  BIGNUM *bn = BN_new();
  BN_set_word(bn, 1);
  printf("%lu\n", BN_get_word(bn));
  BN_free(bn);
  return 0;
}