<head>
    <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
    <script type="text/x-mathjax-config">
        MathJax.Hub.Config({
            tex2jax: {
            skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
            inlineMath: [['$','$']]
            }
        });
    </script>
</head>

# Discussion: The Diffie-Hellman Key-Exchange Algorithm

[return to main](../../../index.md)

[return](../../blogs.md)

The Diffie-Hellman algorithm is a key-exchange algorithm for safe communications in networks.
The algorithm is as follows:
1. the sender sets a prime number $p$, a base number $g$ and a random number $a$
1. the sender calculates $A=g^a\%p$
1. the sender sends $p$, $g$ and $A$ to the receiver
1. the receiver sets a random number $b$
1. the receiver calculates $B=g^b\%p$ and $s1=A^b\%p$
1. the receiver sends $B$ to the sender
1. the sender calculates $s2=B^a\%p$
1. $s1 \equiv s2 = s$, and the shared key is set $s$

In the algorithm, $A$ and $B$ are named public keys; $a$ and $b$ are named private keys.
In communications, private keys are hidden and unknown to other users;
public keys are transmitted through the network.
However, with only public keys, $p$ and $g$, $s$ cannot be determined.
The sender and the receiver can cooperate to determine a shared key without knowledge of each other's private key.

Proof of the algorithm:

let $x$ and $y$ be two positive integers that satisfy:

$$
g^a = px + A \\
g^b = py + B
$$

then,

$$
A^b = (g^a-px)^b \\
A^b\%p = (g^{ab}-C_b^1\times g^{a(b-1)}px+C_b^2\times g^{a(b-2)}(px)^2+\cdots)\%p = g^{ab}\%p
$$

Similarly,

$$
B^a\%p = g^{ab}\%p
$$

Therefore, $s1 \equiv s2$.

[return](../../blogs.md)

[return to main](../../../index.md)
