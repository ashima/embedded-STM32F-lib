
/**
  * @brief       C++ Templates that implement an ML like structure to 
  *              allow scripting of constance and functions directly.
  * @author      Ian McEwan, Ashima Arts
  * @copyright   Copyright (C) 2013 Ashima Research. All rights reserved.
  *              Distributed under the MIT License. See LICENSE file.
  *
  * I started this years ago and fuctions get updated or writen as I 
  * need them :). Really need better and more test cases.
 */

namespace meta_script {
// Boolean Adapters.
template<class X,class Y> struct eq   { };
template<class X,class Y> struct lt   { };
template<class X,class Y> struct neq  { enum { b = ! eq<X,Y>::b } ; };
template<class X,class Y> struct gt   { enum { b =   lt<Y,X>::b } ; };
template<class X,class Y> struct gteq { enum { b = ! lt<Y,Y>::b } ; };
template<class X,class Y> struct lteq { enum { b = ! lt<Y,X>::b } ; };

// Constant type constructors
template<int I>                     struct Int             { static const int i = I; };
template<int I, int J>              struct lt<Int<I>,Int<J> >   { enum { b = I < J }; };
template<int I, int J>              struct eq<Int<I>,Int<J> >   { enum { b = I == J }; };

template<class A,class B>           struct tup2            { typedef A a; typedef B b;};
template<class A,class B, class C,class D>
struct eq<tup2<A,B>, tup2<C,D> > 
  { 
  enum { b = eq<A,C>::b && eq<B,D>::b };
  };

template<class A,class B,class C>   struct tup3            { typedef A a; typedef B b; typedef C c;};
template<class A,class B,class C,
  class D>                          struct tup4            { typedef A a; typedef B b; typedef C c; typedef D d;};
template<class A,class B,class C,
  class D,class E>                  struct tup5            { typedef A a; typedef B b; typedef C c; typedef D d; typedef E e;};
template<class A,class B,class C,
  class D,class E,class F>          struct tup6            { typedef A a; typedef B b; typedef C c; typedef D d; typedef E e; typedef F f;};

//   structural tests
template<class X,class Y>           struct sequal          { enum { b = false }; };
template<class X>                   struct sequal<X,X>     { enum { b = true }; };

//   the if then else statment
template<bool v,class T, class S>   struct cond            {};
template<class T,class F>           struct cond<1,T,F>     { typedef T r;};
template<class T,class F>           struct cond<0,T,F>     { typedef F r;};


// Lists - Mostly Following ocaml's list module
struct nil { };
template<class I,class T>           struct cons            { typedef I h; typedef T t; };

//let rec length = function
//  | [] -> 0
//  | _::t -> 1 + (length t)
template<class L>                   struct length          { enum { i=1+length<typename L::t>::i };};
template<>                          struct length<nil>     { enum { i=0 };};

//let rec head = function
//  | _ , 0  -> []
//  | [], _  -> []
//  | h::t,n -> h::(head (t,n-1))
template<class L, int N>            struct head            { typedef cons< typename L::h, typename head<typename L::t, N-1>::l> l; };
template<int N>                     struct head<nil, N>    { typedef nil l; };
template<class L>                   struct head<L, 0>      { typedef nil l; };

//let rec tail = function
//  | l , 0  -> l
//  | [], _  -> []
//  | _::t, n -> tail (t,n-1)
template<class L, int N>            struct tail            { typedef typename tail<typename L::t, N-1>::l l; };
template<int N>                     struct tail<nil, N>    { typedef nil l; };
template<class L>                   struct tail<L, 0>      { typedef L l; };

// (* nth:  int 'a list -> 'a          *)

template<class M>                   struct rev
  {  
//let rec rev l =
//  let rec loop acc = function
//    | [] -> acc
//    | h::t -> loop (h::acc) t
  template<class A,class L>   struct loop { typedef typename loop< cons< typename L::h, A>, typename L::t >::l l; };
  template<class A>   struct loop<A,nil>  { typedef A l ; };
//  in
//  loop [] l
  typedef typename loop<nil, M>::l l;
  };

//(* extend: 'a list -> 'a list -> 'a list         *)
//(* append: 'a -> 'a list -> 'a list         *)

//let rec map f = function
//  | [] -> []
//  | h::t -> (f h)::(map f t)
template< template<class> class F,
class L >                           struct map            { typedef cons<typename F<typename L::h>::r, typename map<F,typename L::t>::l > l; };
template<template<class> class F>   struct map<F,nil>     { typedef nil l; };

//(* fold: *)
//(* exists: ('a->bool) -> 'a list -> bool          *)
//(* member: 'a -> 'a list -> bool                  *)
//(* find: ('a->bool) -> 'a list -> 'a             *)
//(* find_all: ('a->bool) -> 'a list -> 'a list    *)



//let rec filter f = function
//  | [] -> []
//  | h::t -> let m = filter (f) t in
//            if (f h) then h::m else m
template< template<class> class F,
class L >                          struct filter
  {
  typedef typename filter<F, typename L::t>::l ft ;
  typedef typename cond< F<typename L::h>::b, cons<typename L::h, ft >, ft >::r l ;
  };
template<template<class> class F>   struct filter<F,nil>  { typedef nil l; };
//let rec slice acc = function
//  | t , 0  -> (rev acc), t
//  | [], _  -> (rev acc), []
//  | h::t,n -> split (h::acc) (t,n-1)
template<class A, class L,int N>    struct slice           { typedef typename slice< cons< typename L::h, A>, typename L::t, N-1>::l l; };
template<class A, int N>            struct slice<A,nil,N>  { typedef tup2<typename rev<A>::l, nil> l; };
template<class A, class L>          struct slice<A,L,0>    { typedef tup2<typename rev<A>::l, L> l; };

//let sort f l =
template< template<class,class> class F,
  class M>                         struct sort
    {
//  let rec merge = function
//    | x, [] -> x
//    | [], y -> y
//    | (hx::tx as x), (hy::ty as y) -> if (f hx hy) then hx::(merge (tx,y))
//                                                   else hy::(merge (x,ty))
  template<class X, class Y>         struct merge {
    typedef typename cond< F<typename X::h, typename Y::h>::b,
                           cons< typename X::h, typename merge<typename X::t, Y>::l >,
                           cons< typename Y::h, typename merge<X, typename Y::t>::l > >::r l;
    };
  template<class X>                  struct merge<X,nil> { typedef X l ; };
  template<class Y>                  struct merge<nil,Y> { typedef Y l ; };
//  let rec rort l =
//    match length l with
//      | 0 -> []
//      | 1 -> l
//      | n -> let h,t = split [] (l,n/2) in
//             merge ((rort h),(rort t))*)
  template<class L, int N=length<L>::i> struct rort
    {
    typedef typename slice<nil, L, N/2>::l ht;

    typedef typename merge< typename rort<typename ht::a>::l ,
                            typename rort<typename ht::b>::l>::l l;
    };
  template<class L> struct rort<L,1>    { typedef L   l; };
  template<int N>   struct rort<nil,N>  { typedef nil l; };
//  in
//  rort l
  typedef typename rort<M>::l l;
  };

// let product l m = 
template<class L, class M >         struct product
  {  
//  let rec loop acc = function
//    | [], _ -> acc
//    | h1::t1, []     -> loop acc (t1,m)
//    | h1::t1, h2::t2 -> loop ((h1,h2)::acc) ((h1::t1),t2)
  template<class A, class X, 
    class Y >                       struct loop           { typedef typename loop<cons<tup2<typename X::h,typename Y::h>,A>, X, typename Y::t>::l l;};
  template<class A, class X>        struct loop<A,X, nil> { typedef typename loop< A, typename X::t, M>::l l; };
  template<class A, class Y>        struct loop<A,nil, Y> { typedef A l;};
//  in loop [] (l,m)
  typedef typename loop<nil, L, M>::l l;
  };

//let rec range = function
//  | b,e when b = e -> []
//  | b,e            -> b::(range (b+1,e))
template<int I, int J>              struct range          { typedef cons< Int<I>, typename range< I+1, J>::l> l; };
template<int I>                     struct range<I,I>     { typedef nil l; };


// Functions that generate code ...

// (* iter: ('a -> () ) -> 'a list -> ()        *)
template< template<class> class F,
class L>                            struct iter {
  static void go()
    { 
    F<typename L::h>::go();
    iter<F,typename L::t>::go();
    };
  };
template<template<class> class F>   struct iter<F,nil>    { static void go() { } ; };

} // namespace



