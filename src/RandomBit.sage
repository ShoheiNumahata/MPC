
from tkinter.tix import S_REGION
from quadratic_residue import square_root
P=  521
t = 1#多項式fの次数
K = GF(P)
n = 3#参加者の数

All_party = (1,2,3,4,7,10,11,12)
Q = (1,2,3)


#personクラスで参加者を定義。
#通信が必要な計算はクラス内には、簡単のため書かないことにする。
class person:
# __init__で関数で変数を定義するためにはself.関数名である必要がある。
#ex. self.coeff = get_f() ではなくself.coeff = self.get_f()
    def __init__(self,Q,t,xi):
        self.t = t
        self.Q = Q
        self.xi = xi
        
    def setdeta(self):#set_dataで各データ生成
        self.s = K.random_element()#Z/pZ上のランダムな値
        
        self.share = self.get_share(self.s,0)#Piのsiに関するshare
        self.reshare = [0 for i in range(len(Q))]#リシェア後のシェアsetdata宣言時は空リスト

    
    def get_share(self,s,round):#[f(1),f(2),,,f(n)]参加者Q[i]のシェアのリストを生成
        share = [0 for i in range(len(Q))]
        self.coeff = [K.random_element() for i in range(t)]#多項式fの係数列
        if round == 0:
            self.s1 = s    
        elif round == 1:
            self.s2 = K(s^2)#リシェアではこのプロトコルを採用
            # print('s2 = ' + str(self.s2) )
            self.s = K(s^2)
            # print('s = ' + str(self.s) )

        for j in range(len(Q)):#シェアのリストのナンバー

            f = self.s
            X = self.Q[j]
            #多項式の次数
            for i in range(t):
                f = K(f + self.coeff[i] * pow(X, i + 1))  
            share[j] = f
        return share

    # def share_square(self,share_r):
    #     self.share = [0 for i in range(len(Q))]
    #     self.share_r = share_r
    #     self.coeff = [K.random_element() for i in range(t)]
    #     for j in range(len(Q)):#シェアのリストのナンバー
            
    #         f = self.share_r_square
    #         X = self.Q[j]
    #         #多項式の次数
    #         for i in range(t):
    #             f = K(f + self.coeff[i] * pow(X, i + 1))  
    #         self.share[j] = f
    #     return self.share 
    
    def sum_share(self,share,round):
        sum = 0
        if round == 1:
            for i in range(len(share)):
                sum = K(sum +la_list[i]*share[i])
        else:
            for i in range(len(share)):
                            sum = K(sum +share[i])
        return sum

    def square_share(self,share):
        square_share = [0 for i in range(len(Q))]
        for i in range(len(Q)):
            square_share[i] = K(share[i]^2)
        return square_share

#  #class Ran2(person):
#     #RandomBit#
#     def __init__(self,Q,t,xi,r):
#         super().__init__(Q,t,xi)
#         self.r = r

#     def re
#今日でr^2のリシェアから復元する。r^2が０だったら停止
#r^2の2乗根を求める。r^2 > p/2でも良しとするが、こんは0<r<p/2


# def generate_reshare_list(Q):
#P1,P2,....Pnを生成
#インスタンス生成
for i in range(len(Q)):
    exec_generateP = ('P' + str(i+1) + '= person(Q,t,Q[' + str(i) + '])')
    exec_setdeta = ('P' + str(i+1) + '.setdeta()')
    exec(exec_generateP)
    exec(exec_setdeta)


#pair-wise step

# def do_reshare():
for i in range(len(Q)):
    for j in range(len(Q)):
        exec_reshare = ('P' + str(i+1) + '.reshare['+str(j)+'] = P'+str(j+1)+'.share['+str(i)+']')
        exec(exec_reshare)

def make_la_vector(x,Q):#[λ1,λ2,....λn]のリスト生成,xは求める人のシェア。sharmir-SSでは秘密は多項式の定数項を求めるので、x＝０
    la_list = [0 for i in range(len(Q))]
    list_num = 0
    for i in Q:
        la = 1
        for j in range(len(Q)):
            p = Q[j]
            if p != i:
                la = K(la * (x - p)/(i - p))
        la_list[list_num] = la
        list_num += 1
    return la_list

la_list = make_la_vector(0,Q)
#　share_rをsumで計算する。そして(share_r)^2を計算して、シェアを生成
# for i in range(len(Q)):
#     #reshareされた[r]に対して[r]*[r]を計算する
#     exec_command = ('P' + str(i +1)+ '.square_r = P' + str(i+1) + '.square_share(P' + str(i+1) + '.reshare)')
#     #r^2を計算すると同時に、シェアを生成
#     exec_command2 = ('P' + str(i +1)+ '.s_r2 = P' + str(i+1) + '.sum_share(P' + str(i+1) + '.square_r)')
#     #[r^2]のMULT protcol
#     exec_share_r2 = ('P' + str(i+1) + '.share_r2 = P' + str(i+1) + '.get_share(P' + str(i+1) + '.s_r2,1)')
#     exec(exec_command)
#     exec(exec_command2)
#     exec(exec_share_r2)

#　share_r=sum(Pi.share)をsumで計算する。そして(share_r)^2を計算して、シェアを生成
for i in range(len(Q)):
    #sumの計算
    exec_command = ('P' + str(i +1)+ '.share_r = P' + str(i+1) + '.sum_share(P' + str(i+1) + '.reshare,0)')
    #ローカルで(share_r・share_r)= share_r^2を計算してその値をシェアする
    exec_share_r2 = ('P' + str(i+1) + '.share_square_r = P' + str(i+1) + '.get_share(P' + str(i+1) + '.share_r,1)')
    exec(exec_command)
    exec(exec_share_r2)

# for i in range(len(Q)):
   
    

##r^2のMULT protcol
##Pi.reshare_r2()には、share_r2の交換した値が入る。
# # pair-wisedな通信
for i in range(len(Q)):
    exec_generate_reshare_r2 =('P' + str(i+1) + '.reshare_r2 = [0 for n in range(len(Q))]')
    exec(exec_generate_reshare_r2)

    for j in range(len(Q)):
        exec_reshare = ('P' + str(i+1) + '.reshare_r2['+str(j)+'] = P'+str(j+1)+'.share_square_r['+str(i)+']')
        exec(exec_reshare)

# #reshare_r2からreconst_vectorを用いた計算でr^2のshareを生成

for i in range(len(Q)):
    exec_command = 'P' + str(i +1)+ '.share_r2 = P' + str(i+1) + '.sum_share(P' + str(i+1) + '.reshare_r2,1)'
    exec(exec_command)

shr2 = [0 for i in range(len(Q))]
for i in range(len(Q)):
    exec_command = ('shr2[' +str(i) + '] = P'+ str(i + 1) +  '.share_r2' )
    exec(exec_command)

def reconst(reconst_vector,shQ):
    ans = 0

    for i in range(len(shQ)):
        ans += K(reconst_vector[i]*shQ[i])

    return ans

r2 = reconst(la_list,shr2)

if r2 == 0:
    print("rを選び直し")

r2_square_root =square_root(r2,P)

def r2_mod_reduction(r2_square_root):#square_rootを(P-1)/2以下にする
    
    r2_square_root = int(r2_square_root)
    if r2_square_root < (P-1)/2:
        return K(r2_square_root)
    else:
        return K(P - r2_square_root)

b = r2_mod_reduction(r2_square_root)

for i in range(len(Q)):
    exec_command = 'P' + str(i+1)+ '.share_c = K(K(b).inverse_of_unit() * P' + str(i+1) + '.share_r)'
    
    exec(exec_command)

for i in range(len(Q)):
    exec_command = 'P' + str(i+1)+ '.share_d = K(K(2).inverse_of_unit() * (P' + str(i+1) + '.share_c + 1))'
    exec(exec_command)

shc = (P1.share_c,P2.share_c,P3.share_c)
shd = (P1.share_d,P2.share_d,P3.share_d)

#プロトコルの確認作業
c = reconst(la_list,shc)
d = reconst(la_list,shd)
# if r2_square_root > (P - 1)/2:
#     r2_square_root = P - r2_square_root
        


# r2_square_root = modify(r2_square_root)

#プロトコルの確認
#ｒが正しくshare_rでシェアが生成されているか
r = K(P1.s1 + P2.s1 +P3.s1)

r2 = K(pow(r,2))
share_r = (P1.share_r,P2.share_r,P3.share_r)
reconst_r = reconst(la_list,share_r) 



def correct(A,B):
    if A == B:
        print('true')
        
    else:
        print('false')
        print('A=' + str(A))
        print('B=' + str(B))

    return 0




# if root_r2(r2):
#     r = K(r2).nht_root(2)
#     if r < p-1/2:
#         return r
#     else:
#         retunn P -r



# def convert_
# 

# #share_listに復元用の列を用意
# la_list = make_la_vector(0,Q)
# share_list = [0 for i in range(len(Q))]
# for i in range(len(Q)):
#     exec_command = ('share_list[i] = P' + str(i+1) + '.sum_share()')
#     exec(exec_command)
    
# #ランダムにシェアされた値を復元
# def reconst(reconst_vector,shQ):
#     ans = 0
#     for i in range(len(shQ)):
#         ans += K(reconst_vector[i]*shQ[i])

#     if ans == 0:
#         print("rを選び直し")
#     return ans


# # リシェアを獲得、multipricationプロトコル
# # def get_reshare(share,Q,i)

# #    for i in range(len(Q)):


# # def reconst(x,Q,shQ):#Reconst関数  Report1.3
# #   cal_s = 0
# #   l_list = [la(x,i,Q) for i in Q]#[λ1,λ2,....λn]のリスト生成
# #   for i in range(len(Q)):
# #     cal_s =  cal_s + l_list[i] * shQ[i]

# #   return cal_s


# # #shQ = share(t,s,party)

# # def get_llist(x,Q):
# #   k = 0
# #   l_list = [ 0 for i in range(len(Q))]
# #   for i in Q:
    
# #     la = 1
# #     for j in range(len(Q)):
# #       p = Q[j]
# #       if p != i:
# #           la =  la * (x-p) / (i -p) 
# #     l_list[k] = la
# #     k += 1

# #   return l_list

# # def get_f(l_list,Q,shQ):
# #   f = 0;
# #   for i in range(len(Q)):
# #     f = f + l_list[i]* shQ[i]

# #   return f


# # l_list = get_llist(x,Q)#recosntract Vector




# #各パーティーが秘密siを生成して、それを元にt次多項式を生成、siをシェアする get [si] = [[si]0,[si]1,.....[si]n-1]
    






  

  