class PageController < ApplicationController

  def test
    render :layout => false
  end

  def index

    # start over?
    if params[:r]
      session[:total] = nil
      session[:remaining] = nil
      session[:correct] = nil
      session[:tries] = nil
    end
    
    # initialize this practice
    session[:total] ||= Question.all.count
    session[:remaining] ||= Question.all.collect {|q| q.id}
    session[:correct] ||= []
    session[:tries] ||= -1  # first load doesn't count

    # record results of previous question
    session[:tries] = session[:tries] + 1
    if params[:c]
      session[:correct].push(params[:c].to_i).uniq!
      session[:remaining].delete(params[:c].to_i)
    end

    # pull either a) a specific question, b) a random unanswered question, or c) a random question
    @question = Question.find(params[:q]) if params[:q]
    @question ||= Question.find(session[:remaining].choice) if session[:remaining].size > 0
    @question ||= Question.all.choice

    if session[:remaining].empty? and session[:correct].size == session[:total]
      @congrats = true
    end

  end


  
#  DATA = {
#        "Array" => [
#              ["", "Arrays are ordered, integer-indexed collections of any object. Array indexing starts at 0, as in C or Java. A negative index is assumed to be relative to the end of the array—that is, an index of -1 indicates the last element of the array, -2 is the next to last element in the array, and so on."],
#              ["&", "Set Intersection—Returns a new array containing elements common to the two arrays, with no duplicates.<br><br>"],
#              ["*", "Repetition—With a String argument, equivalent to self.join(str). Otherwise, returns a new array built by concatenating the int copies of self.<br><br>   [ 1, 2, 3 ] * 3    #=> [ 1, 2, 3, 1, 2, 3, 1, 2, 3 ]<br>   [ 1, 2, 3 ] * ','  #=> '1,2,3'"],
#              ["+", "Concatenation—Returns a new array built by concatenating the two arrays together to produce a third array.<br><br>   [ 1, 2, 3 ] + [ 4, 5 ]    #=> [ 1, 2, 3, 4, 5 ]"],
#              ["-", "Array Difference—Returns a new array that is a copy of the original array, removing any items that also appear in other_array. (If you need set-like behavior, see the library class Set.)<br><br>   [ 1, 1, 2, 2, 3, 3, 4, 5 ] - [ 1, 2, 4 ]  #=>  [ 3, 3, 5 ]"],
#              ["<<", "Append—Pushes the given object on to the end of this array. This expression returns the array itself, so several appends may be chained together.<br><br>[ 1, 2 ] << 'c' << 'd' << [ 3, 4 ] #=>  [ 1, 2, 'c', 'd', [ 3, 4 ] ]"],
#              ["<=>", "Comparison—Returns an integer (-1, 0, or +1) if this array is less than, equal to, or greater than other_array. Each object in each array is compared (using <=>). If any value isn‘t equal, then that inequality is the return value. If all the values found are equal, then the return is based on a comparison of the array lengths. Thus, two arrays are ``equal’’ according to Array#<=> if and only if they have the same length and the value of each element is equal to the value of the corresponding element in the other array.<br><br>   [ 'a', 'a', 'c' ]    <=> [ 'a', 'b', 'c' ]   #=> -1<br>   [ 1, 2, 3, 4, 5, 6 ] <=> [ 1, 2 ]            #=> +1"],
#              ["==", "Equality—Two arrays are equal if they contain the same number of elements and if each element is equal to (according to Object.==) the corresponding element in the other array.<br><br><br>   [ 'a', 'c' ]    == [ 'a', 'c', 7 ]     #=> false<br>   [ 'a', 'c', 7 ] == [ 'a', 'c', 7 ]     #=> true<br>   [ 'a', 'c', 7 ] == [ 'a', 'd', 'f' ]   #=> false"],
#              ["[]", "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range.<br><br><br>   a = [ 'a', 'b', 'c', 'd', 'e' ]<br>   a[2] +  a[0] + a[1]    #=> 'cab'<br>   a[6]                   #=> nil<br>   a[1, 2]                #=> [ 'b', 'c' ]<br>   a[1..3]                #=> [ 'b', 'c', 'd' ]<br>   a[4..7]                #=> [ 'e' ]<br>   a[6..10]               #=> nil<br>   a[-3, 3]               #=> [ 'c', 'd', 'e' ]<br>   # special cases<br>   a[5]                   #=> nil<br>   a[5, 1]                #=> []<br>   a[5..10]               #=> []"],
#              ["[]=", "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift.<br><br><br>   a = Array.new<br>   a[4] = '4';                 #=> [nil, nil, nil, nil, '4']<br>   a[0, 3] = [ 'a', 'b', 'c' ] #=> ['a', 'b', 'c', nil, '4']<br>   a[1..2] = [ 1, 2 ]          #=> ['a', 1, 2, nil, '4']<br>   a[0, 2] = '?'               #=> ['?', 2, nil, '4']<br>   a[0..2] = 'A'               #=> ['A', '4']<br>   a[-1]   = 'Z'               #=> ['A', 'Z']<br>   a[1..-1] = nil              #=> ['A']"],
#              ["assoc", "Searches through an array whose elements are also arrays comparing obj with the first element of each contained array using obj.==. Returns the first contained array that matches (that is, the first associated array), or nil if no match is found. See also Array#rassoc.<br><br><br>   s1 = [ 'colors', 'red', 'blue', 'green' ]<br>   s2 = [ 'letters', 'a', 'b', 'c' ]<br>   s3 = 'foo'<br>   a  = [ s1, s2, s3 ]<br>   a.assoc('letters')  #=> [ 'letters', 'a', 'b', 'c' ]<br>   a.assoc('foo')      #=> nil"],
#              ["at", "Returns the element at index. A negative index counts from the end of self. Returns nil if the index is out of range. See also Array#[]. (Array#at is slightly faster than Array#[], as it does not accept ranges and so on.)<br><br><br>   a = [ 'a', 'b', 'c', 'd', 'e' ]<br>   a.at(0)     #=> 'a'<br>   a.at(-1)    #=> 'e'"],
#              ["choice", "Choose a random element from an array."],
#              ["clear", "Removes all elements from self.<br><br><br>   a = [ 'a', 'b', 'c', 'd', 'e' ]<br>   a.clear    #=> [ ]"],
#              ["collect", "Invokes block once for each element of self. Creates a new array containing the values returned by the block. See also Enumerable#collect.<br><br><br>   a = [ 'a', 'b', 'c', 'd' ]<br>   a.collect {|x| x + '!' }   #=> ['a!', 'b!', 'c!', 'd!']<br>   a                          #=> ['a', 'b', 'c', 'd']"],
#              ["collect!", "Invokes the block once for each element of self, replacing the element with the value returned by block. See also Enumerable#collect.<br><br><br>   a = [ 'a', 'b', 'c', 'd' ]<br>   a.collect! {|x| x + '!' }<br>   a             #=>  [ 'a!', 'b!', 'c!', 'd!' ]"],
#              ["combination", "When invoked with a block, yields all combinations of length n of elements from ary and then returns ary itself. The implementation makes no guarantees about the order in which the combinations are yielded.<br><br>When invoked without a block, returns an enumerator object instead.<br><br>Examples:<br><br>    a = [1, 2, 3, 4]<br>    a.combination(1).to_a  #=> [[1],[2],[3],[4]]<br>    a.combination(2).to_a  #=> [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]<br>    a.combination(3).to_a  #=> [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]<br>    a.combination(4).to_a  #=> [[1,2,3,4]]<br>    a.combination(0).to_a  #=> [[]] # one combination of length 0<br>    a.combination(5).to_a  #=> []   # no combinations of length 5"],
#              ["compact", "Returns a copy of self with all nil elements removed.<br><br><br>   [ 'a', nil, 'b', nil, 'c', nil ].compact<br>                     #=> [ 'a', 'b', 'c' ]"],
#              ["compact!", "Removes nil elements from array. Returns nil if no changes were made.<br><br>   [ 'a', nil, 'b', nil, 'c' ].compact! #=> [ 'a', 'b', 'c' ]<br>   [ 'a', 'b', 'c' ].compact!           #=> nil"],
#              ["concat", "Appends the elements in other_array to self.<br><br>[ 'a', 'b' ].concat( ['c', 'd'] ) #=> [ 'a', 'b', 'c', 'd' ]"],
#              ["count", "Returns the number of elements. If an argument is given, counts the number of elements which equals to obj. If a block is given, counts the number of elements yielding a true value.<br><br><br>   ary = [1, 2, 4, 2]<br>   ary.count             # => 4<br>   ary.count(2)          # => 2<br>   ary.count{|x|x%2==0}  # => 3"],
#              ["cycle", "Calls block for each element repeatedly n times or forever if none or nil is given. If a non-positive number is given or the array is empty, does nothing. Returns nil if the loop has finished without getting interrupted.<br><br><br>   a = ['a', 'b', 'c']<br>   a.cycle {|x| puts x }  # print, a, b, c, a, b, c,.. forever.<br>   a.cycle(2) {|x| puts x }  # print, a, b, c, a, b, c."],
#              ["delete", "Deletes items from self that are equal to obj. If the item is not found, returns nil. If the optional code block is given, returns the result of block if the item is not found.<br><br><br>   a = [ 'a', 'b', 'b', 'b', 'c' ]<br>   a.delete('b')                   #=> 'b'<br>   a                               #=> ['a', 'c']<br>   a.delete('z')                   #=> nil<br>   a.delete('z') { 'not found' }   #=> 'not found'"],
#              ["delete_at", ""],
#              ["delete_if", ""],
#              ["drop", ""],
#              ["drop_while", ""],
#              ["each", ""],
#              ["each_index", ""],
#              ["empty?", ""],
#              ["eql?", ""],
#              ["fetch", ""],
#              ["fill", ""],
#              ["find_index", ""],
#              ["first", ""],
#              ["flatten", ""],
#              ["flatten!", ""],
#              ["frozen?", ""],
#              ["hash", ""],
#              ["include?", ""],
#              ["index", ""],
#              ["indexes", ""],
#              ["indices", ""],
#              ["initialize_copy", ""],
#              ["insert", ""],
#              ["inspect", ""],
#              ["join", ""],
#              ["last", ""],
#              ["length", ""],
#              ["map", ""],
#              ["map!", ""],
#              ["new", ""],
#              ["nitems", ""],
#              ["pack", ""],
#              ["permutation", ""],
#              ["pop", ""],
#              ["product", ""],
#              ["push", ""],
#              ["rassoc", ""],
#              ["reject", ""],
#              ["reject!", ""],
#              ["replace", ""],
#              ["reverse", ""],
#              ["reverse!", ""],
#              ["reverse_each", ""],
#              ["rindex", ""],
#              ["select", ""],
#              ["shift", ""],
#              ["shuffle", ""],
#              ["shuffle!", ""],
#              ["size", ""],
#              ["slice", ""],
#              ["slice!", ""],
#              ["sort", ""],
#              ["sort!", ""],
#              ["take", ""],
#              ["take_while", ""],
#              ["to_a", ""],
#              ["to_ary", ""],
#              ["to_s", ""],
#              ["transpose", ""],
#              ["uniq", ""],
#              ["uniq!", ""],
#              ["unshift", ""],
#              ["values_at", ""],
#              ["zip", ""],
#              ["|", ""]
#        ],
#        "Bignum" => [
#              ["%", ""],
#              ["&", ""],
#              ["*", ""],
#              ["**", ""],
#              ["+", ""],
#              ["-", ""],
#              ["-@", ""],
#              ["/", ""],
#              ["<<", ""],
#              ["<=>", ""],
#              ["==", ""],
#              [">>", ""],
#              ["[]", ""],
#              ["^", ""],
#              ["abs", ""],
#              ["coerce", ""],
#              ["div", ""],
#              ["divmod", ""],
#              ["eql?", ""],
#              ["fdiv", ""],
#              ["hash", ""],
#              ["modulo", ""],
#              ["quo", ""],
#              ["remainder", ""],
#              ["size", ""],
#              ["to_f", ""],
#              ["to_s", ""],
#              ["|", ""],
#              ["~", ""]
#        ],
#        "Binding" => [
#              ["clone", ""],
#              ["eval", ""]
#        ],
#        "Class" => [
#              ["allocate", ""],
#              ["inherited", ""],
#              ["new", ""],
#              ["superclass", ""]
#        ],
#        "Comparable" => [
#              ["<", ""],
#              ["<=", ""],
#              ["==", ""],
#              [">", ""],
#              [">=", ""],
#              ["between?", ""]
#        ],
#        "Continuation" => [
#              ["[]", ""],
#              ["call", ""]
#        ],
#        "Dir" => [
#              ["[]", ""],
#              ["chdir", ""],
#              ["chroot", ""],
#              ["close", ""],
#              ["delete", ""],
#              ["each", ""],
#              ["entries", ""],
#              ["foreach", ""],
#              ["getwd", ""],
#              ["glob", ""],
#              ["inspect", ""],
#              ["mkdir", ""],
#              ["new", ""],
#              ["open", ""],
#              ["path", ""],
#              ["pos", ""],
#              ["pos=", ""],
#              ["pwd", ""],
#              ["read", ""],
#              ["rewind", ""],
#              ["rmdir", ""],
#              ["seek", ""],
#              ["tell", ""],
#              ["unlnk", ""]
#        ],
#        "Enumerable" => [
#              ["all?", ""],
#              ["any?", ""],
#              ["collect", ""],
#              ["count", ""],
#              ["cycle", ""],
#              ["detect", ""],
#              ["drop", ""],
#              ["drop_while", ""],
#              ["each_cons", ""],
#              ["each_slice", ""],
#              ["each_with_index", ""],
#              ["entries", ""],
#              ["enum_cons", ""],
#              ["enum_slice", ""],
#              ["enum_with_index", ""],
#              ["find", ""],
#              ["find_all", ""],
#              ["find_index", ""],
#              ["first", ""],
#              ["grep", ""],
#              ["group_by", ""],
#              ["include?", ""],
#              ["inject", ""],
#              ["map", ""],
#              ["max", ""],
#              ["max_by", ""],
#              ["member?", ""],
#              ["min", ""],
#              ["min_by", ""],
#              ["minmax", ""],
#              ["minmax_by", ""],
#              ["none?", ""],
#              ["one?", ""],
#              ["partition", ""],
#              ["reduce", ""],
#              ["reject", ""],
#              ["reverse_each", ""],
#              ["select", ""],
#              ["sort", ""],
#              ["sort_by", ""],
#              ["take", ""],
#              ["take_while", ""],
#              ["to_a", ""],
#              ["zip", ""]
#        ],
#        "Exception" => [
#              ["backtrace", ""],
#              ["exception", ""],
#              ["exception (class method)", ""],
#              ["inspect", ""],
#              ["message", ""],
#              ["new", ""],
#              ["set_backtrace", ""],
#              ["to_s", ""],
#              ["to_str", ""]
#        ]
#  }
#
#  QUESTIONS = [
#        ["", "[ 1, 1, 3, 5 ] & [ 1, 2, 3 ]", "[1,3]", "set intersection"],
#        ["", "[ 1, 2, 3 ] * 3", "[1,2,3,1,2,3,1,2,3]", ""],
#        ["", '[ 1, 2, 3 ] * ","', '"1,2,3"', 'synonym for array.join(str)'],
#        ["", "[ 1, 2, 3 ] + [ 4, 5 ]", "[1,2,3,4,5]", "Concatenation—Returns a new array built by concatenating the two arrays together to produce a third array."],
#        ["", "[ 1, 1, 2, 2, 3, 3, 4, 5 ] - [ 1, 2, 4 ]", "[3,3,5]", "Array Difference—Returns a new array that is a copy of the original array, removing any items that also appear in other_array. (If you need set-like behavior, see the library class Set.)"],
#        ["", '[ 1, 2 ] << "c" << "d" << [ 3, 4 ]', '[1,2,"c","d",[3,4]]', "Append—Pushes the given object on to the end of this array. This expression returns the array itself, so several appends may be chained together."],
#
#        # <=>
#        ["", '[ "a", "a", "c" ]    <=> [ "a", "b", "c" ]', "-1", "Comparison—Returns an integer (-1, 0, or +1) if this array is less than, equal to, or greater than other_array. Each object in each array is compared (using <=>). If any value isn‘t equal, then that inequality is the return value. If all the values found are equal, then the return is based on a comparison of the array lengths. Thus, two arrays are ``equal’’ according to Array#<=> if and only if they have the same length and the value of each element is equal to the value of the corresponding element in the other array."],
#        ["", '[ 1, 2, 3, 4, 5, 6 ] <=> [ 1, 2 ]', "1", "Comparison—Returns an integer (-1, 0, or +1) if this array is less than, equal to, or greater than other_array. Each object in each array is compared (using <=>). If any value isn‘t equal, then that inequality is the return value. If all the values found are equal, then the return is based on a comparison of the array lengths. Thus, two arrays are ``equal’’ according to Array#<=> if and only if they have the same length and the value of each element is equal to the value of the corresponding element in the other array."],
#
#        # ==
#        ["", '[ "a", "c" ]    == [ "a", "c", 7 ]', "false", "quality—Two arrays are equal if they contain the same number of elements and if each element is equal to (according to Object.==) the corresponding element in the other array."],
#        ["", '[ "a", "c", 7 ] == [ "a", "c", 7 ]', "true", "quality—Two arrays are equal if they contain the same number of elements and if each element is equal to (according to Object.==) the corresponding element in the other array."],
#        ["", '[ "a", "c", 7 ] == [ "a", "d", "f" ]', "false", "quality—Two arrays are equal if they contain the same number of elements and if each element is equal to (according to Object.==) the corresponding element in the other array."],
#
#        # []
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[2] +  a[0] + a[1]', '"cab"', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[6]', 'nil', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[1, 2]', '["b","c"]', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[1..3]', '["b","c","d"]', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[4..7]', '["e"]', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[6..10]', 'nil', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[-3, 3]', '["c","d","e"]', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[5]', 'nil', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[5, 1]', '[]', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a[5..10]', '[]', "Element Reference—Returns the element at index, or returns a subarray starting at start and continuing for length elements, or returns a subarray specified by range. Negative indices count backward from the end of the array (-1 is the last element). Returns nil if the index (or starting index) are out of range"],
#
#        # []=
#        ['a = Array.new', 'a[4] = "4"', '[nil,nil,nil,nil,"4"]', "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift."],
#        ['a = [nil,nil,nil,nil,"4"]<br>a[0, 3] = [ "a", "b", "c" ]', 'a', '["a","b","c",nil,"4"]', "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift."],
#        ['a = ["a", "b", "c", nil, "4"]<br>a[1..2] = [ 1, 2 ]', 'a', '["a",1,2,nil,"4"]', "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift."],
#        ['a = ["a", 1, 2, nil, "4"]<br>a[0, 2] = "?"', 'a', '["?",2,nil,"4"]', "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift."],
#        ['a = ["?", 2, nil, "4"]<br>a[0..2] = "A"', 'a', '["A","4"]', "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift."],
#        ['a = ["A", "4"]<br>a[-1] = "Z"', 'a', '["A","Z"]', "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift."],
#        ['a = ["A", "Z"]<br>a[1..-1] = nil', 'a', '["A"]', "Element Assignment—Sets the element at index, or replaces a subarray starting at start and continuing for length elements, or replaces a subarray specified by range. If indices are greater than the current capacity of the array, the array grows automatically. A negative indices will count backward from the end of the array. Inserts elements if length is zero. If nil is used in the second and third form, deletes elements from self. An IndexError is raised if a negative index points past the beginning of the array. See also Array#push, and Array#unshift."],
#
#        # assoc
#        ['s1 = [ "colors", "red", "blue", "green" ]<br>   s2 = [ "letters", "a", "b", "c" ]<br>   s3 = "foo"<br>   a  = [ s1, s2, s3 ]',
#         'a.assoc("letters")',
#         '["letters","a","b","c"]',
#         "Searches through an array whose elements are also arrays comparing obj with the first element of each contained array using obj.==. Returns the first contained array that matches (that is, the first associated array), or nil if no match is found. See also Array#rassoc."],
#        ['s1 = [ "colors", "red", "blue", "green" ]<br>   s2 = [ "letters", "a", "b", "c" ]<br>   s3 = "foo"<br>   a  = [ s1, s2, s3 ]',
#         'a.assoc("foo")',
#         'nil',
#         "Searches through an array whose elements are also arrays comparing obj with the first element of each contained array using obj.==. Returns the first contained array that matches (that is, the first associated array), or nil if no match is found. See also Array#rassoc."],
#
#        # at
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a.at(0)', '"a"', "Returns the element at index. A negative index counts from the end of self. Returns nil if the index is out of range. See also Array#[]. (Array#at is slightly faster than Array#[], as it does not accept ranges and so on.)"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a.at(-1)', '"e"', "Returns the element at index. A negative index counts from the end of self. Returns nil if the index is out of range. See also Array#[]. (Array#at is slightly faster than Array#[], as it does not accept ranges and so on.)"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a.at(5)', 'nil', "Returns the element at index. A negative index counts from the end of self. Returns nil if the index is out of range. See also Array#[]. (Array#at is slightly faster than Array#[], as it does not accept ranges and so on.)"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a.at(-5)', '"a"', "Returns the element at index. A negative index counts from the end of self. Returns nil if the index is out of range. See also Array#[]. (Array#at is slightly faster than Array#[], as it does not accept ranges and so on.)"],
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a.at(-6)', 'nil', "Returns the element at index. A negative index counts from the end of self. Returns nil if the index is out of range. See also Array#[]. (Array#at is slightly faster than Array#[], as it does not accept ranges and so on.)"],
#
#        # choice
#        ['a = [1, 2, 3, 4]', 'a.choice', '???', "Chooses a random object from an array"],
#
#        # clear
#        ['a = [ "a", "b", "c", "d", "e" ]', 'a.clear', '[]', "Removes all elements from self."],
#
#        # collect
#        ['a = [ "a", "b", "c", "d" ]', 'a.collect {|x| x + "!" }', '["a!","b!","c!","d!"]', "Invokes block once for each element of self. Creates a new array containing the values returned by the block. See also Enumerable#collect."],
#        ['a = [ "a", "b", "c", "d" ]<br>a.collect {|x| x + "!" }', 'a', '["a","b","c","d"]', "Invokes block once for each element of self. Creates a new array containing the values returned by the block. See also Enumerable#collect."],
#        ['a = [ "a", "b", "c", "d" ]', 'a.map {|x| x + "!" }', '["a!","b!","c!","d!"]', "Invokes block once for each element of self. Creates a new array containing the values returned by the block. See also Enumerable#collect."],
#        ['a = [ "a", "b", "c", "d" ]<br>a.map {|x| x + "!" }', 'a', '["a","b","c","d"]', "Invokes block once for each element of self. Creates a new array containing the values returned by the block. See also Enumerable#collect."],
#
#        # collect!
#        ['a = [ "a", "b", "c", "d" ]<br>a.collect! {|x| x + "!" }', 'a', '["a!","b!","c!","d!"]', "Invokes block once for each element of self. Creates a new array containing the values returned by the block. See also Enumerable#collect."],
#        ['a = [ "a", "b", "c", "d" ]<br>a.map! {|x| x + "!" }', 'a', '["a!","b!","c!","d!"]', "Invokes block once for each element of self. Creates a new array containing the values returned by the block. See also Enumerable#collect."],
#
#        # combination
#        ['a = [1, 2, 3, 4]', 'a.combination(1).to_a', '[[1],[2],[3],[4]]', "When invoked with a block, yields all combinations of length n of elements from ary and then returns ary itself. The implementation makes no guarantees about the order in which the combinations are yielded.<br><br>When invoked without a block, returns an enumerator object instead."],
#        ['a = [1, 2, 3, 4]', 'a.combination(2).to_a', '[[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]', "When invoked with a block, yields all combinations of length n of elements from ary and then returns ary itself. The implementation makes no guarantees about the order in which the combinations are yielded.<br><br>When invoked without a block, returns an enumerator object instead."],
#        ['a = [1, 2, 3, 4]', 'a.combination(3).to_a', '[[1,2,3],[1,2,4],[1,3,4],[2,3,4]]', "When invoked with a block, yields all combinations of length n of elements from ary and then returns ary itself. The implementation makes no guarantees about the order in which the combinations are yielded.<br><br>When invoked without a block, returns an enumerator object instead."],
#        ['a = [1, 2, 3, 4]', 'a.combination(4).to_a', '[[1,2,3,4]]', "When invoked with a block, yields all combinations of length n of elements from ary and then returns ary itself. The implementation makes no guarantees about the order in which the combinations are yielded.<br><br>When invoked without a block, returns an enumerator object instead."],
#        ['a = [1, 2, 3, 4]', 'a.combination(0).to_a', '[[]]', "One combination of length 0<br><br>When invoked with a block, yields all combinations of length n of elements from ary and then returns ary itself. The implementation makes no guarantees about the order in which the combinations are yielded.<br><br>When invoked without a block, returns an enumerator object instead."],
#        ['a = [1, 2, 3, 4]', 'a.combination(5).to_a', '[]', "No combinations of length 5<br><br>When invoked with a block, yields all combinations of length n of elements from ary and then returns ary itself. The implementation makes no guarantees about the order in which the combinations are yielded.<br><br>When invoked without a block, returns an enumerator object instead."],
#
#        # compact
#        ['', '[ "a", nil, "b", nil, "c", nil ].compact', '["a","b","c"]', "Returns a copy of self with all nil elements removed"],
#        ['', '[ "a", nil, "b", nil, "c", nil ].compact!', '["a","b","c"]', "Removes nil elements from array. Returns nil if no changes were made."],
#        ['', '[ "a", "b", "c"].compact!', 'nil', "Removes nil elements from array. Returns nil if no changes were made."],
#
#        # concat
#        ['', '[ "a", "b" ].concat( ["c", "d"] )', '[ "a","b","c","d"]', "Appends the elements in other_array to self."],
#        ['', '[ "a", "b" ].concat( ["c", "d", ["e", "f"]] )', '[ "a","b","c","d",["e","f"]]', "Appends the elements in other_array to self."],
#
#        # count
#        ['a = [1, 2, 4, 2]', 'a.count', '4', "Returns the number of elements. If an argument is given, counts the number of elements which equals to obj. If a block is given, counts the number of elements yielding a true value."],
#        ['a = [1, 2, 4, 2]', 'a.count(2)', '2', "Returns the number of elements. If an argument is given, counts the number of elements which equals to obj. If a block is given, counts the number of elements yielding a true value."],
#        ['a = [1, 2, 4, 2]', 'a.count{ |x| x%2 == 0 }', '3', "Returns the number of elements. If an argument is given, counts the number of elements which equals to obj. If a block is given, counts the number of elements yielding a true value."],
#
#        # cycle
#        ['a = ["a", "b", "c"]', 'a.cycle {|x| puts x }', 'print, a, b, c, a, b, c,.. forever.', "Calls block for each element repeatedly n times or forever if none or nil is given. If a non-positive number is given or the array is empty, does nothing. Returns nil if the loop has finished without getting interrupted."],
#        ['a = ["a", "b", "c"]', 'a.cycle(2) {|x| puts x }', 'print, a, b, c, a, b, c', "Calls block for each element repeatedly n times or forever if none or nil is given. If a non-positive number is given or the array is empty, does nothing. Returns nil if the loop has finished without getting interrupted."],
#
#        # delete
#        ['a = [ "a", "b", "b", "b", "c" ]', 'a.delete("b")', '"b"', "Deletes items from self that are equal to obj. If the item is not found, returns nil. If the optional code block is given, returns the result of block if the item is not found."],
#        ['a = [ "a", "b", "b", "b", "c" ]<br>a.delete("b")', 'a', '["a","c"]', "Deletes items from self that are equal to obj. If the item is not found, returns nil. If the optional code block is given, returns the result of block if the item is not found."],
#        ['a = [ "a", "c" ]', 'a.delete("z")', 'nil', "Deletes items from self that are equal to obj. If the item is not found, returns nil. If the optional code block is given, returns the result of block if the item is not found."],
#        ['a = [ "a", "c" ]', 'a.delete("z"){"not found"}', '"not found"', "Deletes items from self that are equal to obj. If the item is not found, returns nil. If the optional code block is given, returns the result of block if the item is not found."],
#
#        # delete_at
#        ['a = %w( ant bat cat dog )', 'a.delete_at(2)', '"cat"', "Deletes the element at the specified index, returning that element, or nil if the index is out of range. See also Array#slice!."],
#        ['a = %w( ant bat cat dog )<br>a.delete_at(2)', 'a', '["ant","bat","dog"]', "Deletes the element at the specified index, returning that element, or nil if the index is out of range. See also Array#slice!."],
#        ['a = %w( ant bat cat dog )', 'a.delete_at(99)', 'nil', "Deletes the element at the specified index, returning that element, or nil if the index is out of range. See also Array#slice!."],
#
#        # delete_if
#        ['a = [ "a", "b", "c" ]', 'a.delete_if {|x| x >= "b" }', '["a"]', "Deletes every element of self for which block evaluates to true"],
#        ['a = [ "a", "b", "c" ]<br>a.delete_if {|x| x >= "b" }', 'a', '["a"]', "Deletes every element of self for which block evaluates to true"],
#
#        # drop
#        ['a = [1, 2, 3, 4, 5, 0]', 'a.drop(3)', '[4,5,0]', "Drops first n elements from array, and returns the rest of the elements in an array."],
#        ['a = [1, 2, 3, 4, 5, 0]<br>a.drop(3)', 'a', '[1,2,3,4,5,0]', "Drops first n elements from array, and returns the rest of the elements in an array."],
#
#  ]

end
