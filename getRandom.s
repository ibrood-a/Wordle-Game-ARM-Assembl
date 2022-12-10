        .arch   armv7-a
        .fpu    vfpv3-d16
        .syntax unified

        .text
        .align  2

        .global getRandom
        .type   getRandom, %function

getRandom:
        push    {r4, r5, fp, lr}
        add     fp, sp, #12

        @call rand
        mov     r4, r0                                  // r4 <- r0, "min"
        mov     r5, r1                                  // r5 <- r1, "range"
        bl      rand                                    // assumes rand() already seeded
        mov     r3, r0                                  // r3 <- r0, ie: returned random number 

        @ call % operator (modulus)
        mov     r1, r5                                  // r1 <- r5, ie: denominator
        mov     r0, r3                                  // r0 <- r3, ie: returned random number
        bl      __aeabi_idivmod                         // divide r0 by r1, return quotient in r0 a$
        mov     r2, r1                                  // r2 <- r1, r1 = remainder                $
        mov     r3, r4                                  // r3 <- r4, ie: min
        add     r0, r2, r3                              // r0 <- r2 + r3 ( scales the value)

        @epilogue
        pop     {r4, r5, fp, pc}
        