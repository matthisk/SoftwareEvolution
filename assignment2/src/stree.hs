module STree where

import Prelude

data STree alf = Leaf | Branch [(Label alf,STree alf)] deriving (Eq, Show)
type Label alf = ([alf],Int)
type EdgeFunction alf = [[alf]]->(Int,[[alf]])

isTword::(Eq alf)=>(Label alf)->(STree alf)->Bool
isTword (a:w,0) (Branch es) = [] /= [0 | ((c:_,_),_)<-es, a == c]
isTword (a:w,wlen) (Branch es)
    | wlen < 1 = error "Wlen has to be bigger than 0"
    | Leaf == node || (wlen-1) < ulen = w!!(wlen-1) == u!!(wlen-1)
    | otherwise = isTword (drop ulen w,(wlen-1)-ulen) node
    where (u,ulen,node) = head [(u,culen-1,node) | ((c:u,culen),node)<-es, a == c]

update::(Ord alf)=>(STree alf, Label alf) -> (STree alf, Label alf)
update (root,(s,slen))
    | isTword (s,slen) root = (root,(s,slen+1))
    | 0 == slen = (root',(tail s,0))
    | otherwise = update (root',(tail s,slen-1))
        where root' = insRelSuff (s,slen) root

insRelSuff::(Ord alf)=>(Label alf)->(STree alf)->(STree alf)
insRelSuff (aw@(a:w),0) (Branch es) = Branch (g es)
    where g [] = [((aw,length aw),Leaf)]
          g (cusn@((c:u,culen),node):es')
            | a > c = cusn:g es'
            | otherwise = ((aw,length aw),Leaf):cusn:es'
insRelSuff (aw@(a:w),slen) (Branch es) = Branch (g es)
    where g (cusn@(cus@(cu@(c:_),culen),node):es')
            | a /= c = cusn:g es'
            | Leaf /= node && slen >= culen = (cus,node'):es'
            | head x < head y = ((cu,slen),Branch [ex,ey]):es'
            | otherwise = ((cu,slen),Branch [ey,ex]):es'
               where node' = insRelSuff (drop culen aw,slen-culen) node
                     x = drop slen cu
                     y = drop slen aw
                     ex | Leaf == node = ((x,length x),Leaf)
                       | otherwise = ((x,culen-slen),node)
                     ey = ((y,length y),Leaf)

naiveOnline::(Ord alf)=>[alf]->STree alf
naiveOnline t = fst (until stop update (Branch [],(t,0)))
    where stop (_,(s,slen)) = [] == drop slen s