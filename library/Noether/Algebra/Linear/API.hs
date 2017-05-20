{-# LANGUAGE TypeApplications #-}
module Noether.Algebra.Linear.API where

import           Noether.Lemmata.Prelude
import           Noether.Lemmata.TypeFu

import           Noether.Algebra.Actions
import           Noether.Algebra.Multiple
import           Noether.Algebra.Single
import           Noether.Algebra.Single.Synonyms
import           Noether.Algebra.Tags

import           Noether.Algebra.Linear.Module
import           Noether.Algebra.Linear.Strategies

type LeftModule' r v = LeftModule Mul Add Mul r Add v
type RightModule' r v = RightModule Mul Add Mul r Add v

(%<) :: LeftActs 'Mul r v => r -> v -> v
r %< v = leftAct @Mul r v

(>%) :: RightActs 'Mul r v => v -> r -> v
v >% r = rightAct @Mul r v

-- | Locally use the self-action induced by the multiplicative magma structure
-- of the ring, whatever structure the user may have chosen to use globally.
(~>%) :: forall r. Ring Add Mul r => r -> r -> r
a ~>% b = rightActK @Mul @(DeriveActs_Magma Mul r) a b

-- | Linear interpolation.
-- > lerp λ v w = λv + (1 - λ)w

lerp ::
  ( Neutral 'Mul r
  , Cancellative 'Add r
  , Magma 'Add r, Magma 'Add a
  , Acts 'R 'Mul r a
  , Acts 'L 'Mul r a
  ) => r -> a -> a -> a
lerp lambda v w = lambda %< v + w >% (one - lambda)
