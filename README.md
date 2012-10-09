maxsum-matlab
=============

This library provides a basic matlab implementation of the maxsum algorithm.

Getting Started
===============
Run the following at the matlab prompt:
maxSumHarness(2,2);

This will run the max-sum algorith on a acyclic factor graph of depth 2, with branching factor 2. This result is compared against the result of the standard max function applied to the sum of all the factors in the factor graph.

Known Issues
============
This code was originally part of a large library developed for personal use, so documentation is currently sparse in places. Also with hindsight, there are several changes that could be made to improve the performance and readability of the code. In particular, the msfun class, which represents discrete functions that may depend on overlapping sets of variables, is currently written using the old style for object oriented code in matlab. Updating this to the new style would streamline the code and make it more readable. There are also several changes that could be made to improve performance. For example, we currently overload some of the standard Matlab functions for cell arrays. Generally, overloading builtin functions for builtin types is not recommended by Mathworks, as it may impact on performance. In future versions, we may look into alternative strategies.

Related Libraries
=================
We are currently working on a C++ implementation which can be found <a href="https://github.com/lteacy/maxsum-cpp">here.</a> 

License
=======
Copyright © 2012 Luke Teacy. All Rights Reserved.

Redistribution and use of this software in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY LUKE TEACY "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

