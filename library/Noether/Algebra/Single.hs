{-| FULLPOLYMORPHIC™ algebraic structures supporting a single operation.

-}
module Noether.Algebra.Single
  (
  -- * Semigroup identities
    zero
  , one
  -- * Magma operations
  , (+)
  , (*)
  -- * Group operations
  , (-)
  , (/)
  -- * Logical functions
  , (&&)
  , (||)
  -- * Internal functions
  , cancel
  , reciprocal

  -- * Algebraic structures

  , module Noether.Algebra.Single.Cancellative
  , module Noether.Algebra.Single.Commutative
  , module Noether.Algebra.Single.Neutral
  , module Noether.Algebra.Single.Magma
  , module Noether.Algebra.Single.Monoid
  , module Noether.Algebra.Single.Semigroup
  , module Noether.Algebra.Single.Group
  , module Noether.Algebra.Single.AbelianGroup

  -- * Strategies

  , module Noether.Algebra.Single.Strategies

  -- * Convenient type synonyms

  , module Noether.Algebra.Single.Synonyms
  ) where

import           Noether.Algebra.Single.API

import           Noether.Algebra.Single.Cancellative
import           Noether.Algebra.Single.Commutative
import           Noether.Algebra.Single.Neutral

import           Noether.Algebra.Single.Magma
import           Noether.Algebra.Single.Monoid
import           Noether.Algebra.Single.Semigroup

import           Noether.Algebra.Single.AbelianGroup
import           Noether.Algebra.Single.Group

import           Noether.Algebra.Single.Strategies
import           Noether.Algebra.Single.Synonyms
