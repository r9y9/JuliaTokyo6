# 事前準備
# @time using PCLCommon,PCLVisualization,PCLIO,PCLFilters,CVCore,Cxx,Gallium;

@time using Cxx

# C++ REPL
C++ > #include <iostream>
C++ > std::cout << "こんにちは" << std::endl;

# cxx_str macro
julia> cxx"""
       template <typename T>
       T f(T x) { return x + 10; }
       """

# icxx_str macro
# JuliaからC++を呼ぶ
julia> icxx"f(10);"

julia> for i in 1:10
           println(icxx"f($i);")
       end

# グローバル変数の定義
julia> cxx"""
      std::string cxxstr = "test";
      """

# C++の型がJuliaで型を持つ話し
julia> icxx"cxxstr;"
(class std::__1::basic_string<char>) {
}

julia> icxx"cxxstr;" |> typeof
Cxx.CppValue{Cxx.CxxQualType{Cxx.CppTemplate{Cxx.CppBaseType{Symbol("std::__1::basic_string")},Tuple{UInt8,Cxx.CxxQualType{Cxx.CppTemplate{Cxx.CppBaseType{Symbol("std::__1::char_traits")},Tuple{UInt8}},(false,false,false)},Cxx.CxxQualType{Cxx.CppTemplate{Cxx.CppBaseType{Symbol("std::__1::allocator")},Tuple{UInt8}},(false,false,false)}}},(false,false,false)},24}

julia> icxx"cxxstr;" |> unsafe_string
"test"

julia> icxx"cxxstr;" |> unsafe_string |> typeof
String

# C++からJuliaを呼ぶ
C++> std::cout << $(rand()) << std::endl;
C++> std::cout << $(randn(100000) |> mean) << std::endl;
C++> std::cout << $(randn(100000) |> var) << std::endl;

# C++にJuliaを埋める
julia> using ProgressMeter

julia> cxx"""
       #include <iostream>
       #include <cmath>

       double FooBar(size_t N) {
           double result = 0.0;
           $:(global progress_meter = Progress(icxx"return N;", 1); nothing);
           for (size_t i = 0; i < N; ++i) {
               result = log(1+i) + log(2+i);
               $:(next!(progress_meter); nothing);
           }
           return result;
       }
       """

julia> icxx"FooBar(20000000);"
