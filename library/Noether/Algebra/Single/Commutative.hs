module Noether.Algebra.Single.Commutative where

import qualified Prelude                 as P

import           Noether.Algebra.Tags
import           Noether.Lemmata.Prelude hiding (Num)
import           Noether.Lemmata.TypeFu

data CommutativeE
  = CommutativeNum
  | CommutativeNamed Symbol CommutativeE
  | CommutativeTagged Type CommutativeE

class CommutativeK (op :: k) a (s :: CommutativeE)

instance P.Num a => CommutativeK Add a CommutativeNum
instance P.Num a => CommutativeK Mul a CommutativeNum

instance (KnownSymbol sym, CommutativeK op a s) =>
         CommutativeK op a (CommutativeNamed sym s)

instance (CommutativeK op a s) =>
         CommutativeK op a (CommutativeTagged tag s)

type Commutative op a = CommutativeK op a (CommutativeS op a)

type family CommutativeS (op :: k) (a :: Type) = (r :: CommutativeE)
