from Crypto.Util.number import inverse
p = 9739
a = 497
b = 1768
O = "O" #point at infinity

def modInverse(a, m):
        for x in range(1, m):
                if (((a%m) * (x%m)) % m == 1):
                        return x
        return -1

def div(a, b):
    x = inverse(b, p)
    if(x==-1):
        print("error")
        return -1
    return a*x

def addPoints(P, Q):
    if(P==O):
        return Q
    elif(Q==O):
        return P
    else:
        x1 = P[0]
        y1 = P[1]
        x2 = Q[0]
        y2 = Q[1]

    if(x1==x2 and y1==-y2):
        return O
    else:
        if(P==Q):
            l = div((3*x1*x1+a),(2*y1))%p
        else:
            l = div((y2-y1),(x2-x1))%p
    x3 = (l*l - x1 - x2)%p
    y3 = (l*(x1-x3)-y1)%p
    return [x3,y3]

def scalarMultiply(P,n):
    Q = P
    R = O
    while(n>0):
        if n%2==1:
            R = addPoints(R,Q)
            n = n-1
        else:
            Q = addPoints(Q,Q)
            n = n/2
    return R


print("enter scalar 'n': ",end="")
n = int(input())
print("enter point 'P': ", end="")
P = list(map(str, input().split()))
if(P[0]==O):
    P=O
else:
    P[0] = int(P[0])%p
    P[1] = int(P[1])%p

R = scalarMultiply(P,n)
print("nP = ", end="")
print(R)
