{-# LANGUAGE ConstraintKinds     #-}
{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE PolyKinds           #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeInType          #-}
{-# LANGUAGE TypeOperators       #-}

module EllipticCurve where


import           Lemmata         hiding (Monoid, Semigroup, Semiring,
                                  fromInteger, negate, one, zero, (*), (+), (-),
                                  (/))

import qualified Lemmata         as L

import           Algebra
import           Data.Kind
import           Data.Proxy
import           Data.Reflection

data P2 a = P2 a a
  deriving Show

data P3 a = P3 a a a
  deriving Show

data A2 a = A2 a a
  deriving Show

data A3 a = A3 a a a
  deriving Show

zero' :: Field a => P3 a
zero' = P3 zero one zero

instance (Field a, Eq a) =>
         Eq (P2 a) where
  (P2 a b) == (P2 d e)
    | a == zero && b /= zero = (d == zero) && (e /= zero)
    | a /= zero && b == zero = (d /= zero) && (e == zero)
    | otherwise = (d /= zero) && (e /= zero) && (a / d == b / e)

instance (Field a, Eq a) =>
         Eq (P3 a) where
  (P3 a b c) == (P3 d e f)
    | a == zero && b /= zero =
      (d == zero) && (e /= zero) && P3 b a c == P3 e d f
    | a == zero && c /= zero =
      (d == zero) && (f /= zero) && P3 c b a == P3 f e d
    | b == zero && c /= zero =
      (e == zero) && (f /= zero) && P3 a c b == P3 d f e
    -- now we have a > b > c ito zeroness, a nonzero
    | c == zero = (f == zero) && (P2 a b == P2 d e)
    | otherwise =
      (d /= zero) &&
      (e /= zero) && (f /= zero) && a / d == b / e && b / e == c / f

dehomogenize :: Field a => P3 a -> A2 a
dehomogenize (P3 a b c) = A2 (a / c) (b / c)

-- | Weierstrass model over a field.
-- | This denotes an elliptic curve y^2 = x^3 + ax + b.
data WM a = WM a a

inf :: Field k => P3 k
inf = P3 zero one zero

curve :: Num k => WM k
curve = WM 2 3

-- | char k /= 2 or 3
ellipticPlus
  :: (Field k, Eq k, Num k)
  => WM k -> P3 k -> P3 k -> P3 k
ellipticPlus (WM a _) p q
  | p == inf = q
  | q == inf = p
  | otherwise =
    let A2 xp yp = dehomogenize p
        A2 xq yq = dehomogenize q
    in if xp == xq && yp + yq == zero
         then inf
         else let s =
                    if xp /= xq
                      then (yp - yq) / (xp - xq)
                      else (3 * xp * xp + a) / (2 * yp)
                  x = s * s - xp - xq
                  y = yp + s * (x - xp)
              in ecNegate $ P3 x y 1

ecNegate :: Group a => P3 a -> P3 a
ecNegate (P3 a b c) = P3 a (negate b) c

newtype WM' k = WM' { unWM' :: WM k }

newtype CurvePt k s = CurvePt { unCurvePt :: P3 k }
  deriving Show

type HasWM k s = Reifies s (WM' k)

instance (Field k, Eq k, Num k, HasWM k s) =>
         Semigroup (CurvePt k s) where
  p + q = CurvePt $ ellipticPlus (unWM' $ reflect p) (unCurvePt p) (unCurvePt q)

instance (Field k, Eq k, Num k, HasWM k s) =>
         Monoid (CurvePt k s) where
  zero = CurvePt inf

instance (Field k, Eq k, Num k, HasWM k s) =>
         Cancellative (CurvePt k s) where
  p - q = p + negate q

instance (Field k, Eq k, Num k, HasWM k s) =>
         Group (CurvePt k s) where
  negate = CurvePt . ecNegate . unCurvePt

instance (Field k, Eq k, Num k, HasWM k s) =>
         Abelian (CurvePt k s)

overCurve :: (Field k, Eq k, Num k)
  => WM k -> (forall (s :: *). HasWM k s => CurvePt k s) -> P3 k
overCurve wm ec = reify (WM' wm) (unCurvePt . asProxyOf ec)
  where
    asProxyOf :: f s -> Proxy s -> f s
    asProxyOf e _ = e

pt :: a -> a -> a -> CurvePt a s
pt a b c = CurvePt (P3 a b c)

liftEC :: P3 a -> CurvePt a s
liftEC = CurvePt

sum' :: P3 QQ
sum' = overCurve curve $
  let a = pt 2 3 5
      b = pt 3 5 6
      c = pt 3 5 6
  in a + b - c

-- ellipticPlus'
--   :: (Field k, Eq k, Num k)
--   => ECPoint k wm -> ECPoint k wm -> ECPoint k wm
-- ellipticPlus' (Pt p) (Pt q) = Pt $ ellipticPlus wm p q

-- instance (Field k, Eq k, {- FIXME -} Num k) => Semigroup (ECPoint k wm) where
--   (Pt p) + (Pt q) = Pt $ ellipticPlus wm p q

-- instance (Num k, Eq k, Field k) =>
--          Monoid (ECPoint k wm) where
--   zero = Pt $ \_ -> inf
