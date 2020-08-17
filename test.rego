package http.authz

# by default, assume user is not allowed
default allow = false

allow {
    input.method = "GET"
    input.path = ["salary", user]
    input.user = user
}

numbers {
    x := 123.456e+789
    output := round(x)
    output := abs(x)
    output := numbers.range(a, b)
}

aggregates {
    a := count(collection_or_string)
    b := sum(array_or_set)
    c := product(array_or_set)
    d := max(array_or_set)
    e := min(array_or_set)
    f := sort(array_or_set)
    g := all(array_or_set)
    h := any(array_or_set)
}

arrays {
    a := array.concat(a1, a2)
    b := array.slice(array, startIndex, stopIndex)
}

sets {
    a := s1 & s2
    b := s1 | s2
    c := s1 - s2
    d := intersection(set[set])
    e := union(set[set])
}

objects {
    a := object.get(object, key, "default")
    b := object.remove(object, keys)
    c := object.union(objectA, objectB)
    d := object.filter(object, keys)
    e := json.filter(object, paths)
    f := json.remove(object, paths)
}

strings {
    a := concat(delimiter, array_or_set)
    b := contains(string, search)
    c := format_int(number, base)
    d := indexof(string, search)
    e := lower(string)
    f := replace(string, old, new)
    g := strings.replace_n(patterns, string)
    h := split(string, delimiter)
    i := sprintf(string, values)
    j := startswith(string, search)
    k := trim(string, cutset)
    l := trim_left(string, cutset)
    m := trim_prefix(string, prefix)
    n := trim_right(string, cutset)
    o := trim_suffix(string, suffix)
    p := trim_space(string)
    q := upper(string)
}

regex {
    a := re_match(patterm, value)
    b := regex.split(pattern, string)
    c := regex.globs_match(glob1, glob2)
    d := regex.template_match(pattern, string, delimiter_start, delimiter_end)
    e := regex.find_n(pattern, string, number)
    f := regex.find_all_string_submatch_n(pattern, string, number)
}

glob {
    a := glob.match(pattern, delimiters, match)
    b := glob.quote_meta(pattern)
}

bitwise {
    a := bits.or(x, y)
    b := bits.and(x, y)
    c := bits.negate(x)
    d := bits.xor(x, y)
    e := bits.lsh(x, s)
    f := bits.rsh(x, s)
}

conversions {
    a := to_number(x)
}

units {
    a := units.parse_bytes(x)
}

types {
    a := is_number(x)
    b := is_string(x)
    c := is_boolean(x)
    d := is_array(x)
    e := is_set(x)
    f := is_object(x)
    g := is_null(x)
    h := type_name(x)
}
