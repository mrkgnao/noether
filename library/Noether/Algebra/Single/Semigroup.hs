module Noether.Algebra.Single.Semigroup where

import           Noether.Lemmata.TypeFu

import           Noether.Algebra.Single.Magma
import           Noether.Algebra.Tags

data SemigroupE
  = Semigroup_Magma MagmaE
  | SemigroupNamed Symbol SemigroupE

class SemigroupK (op :: k) a (s :: SemigroupE)

instance MagmaK op a s => SemigroupK op a (Semigroup_Magma s)

instance (KnownSymbol sym, SemigroupK op a s) =>
         SemigroupK op a (SemigroupNamed sym s)

type SemigroupC op a = SemigroupK op a (SemigroupS op a)

type family SemigroupS (op :: k) (a :: Type) = (r :: SemigroupE)

