// Copyright (c) 2013 Roman Neuhauser
// Distributed under the MIT license (see LICENSE file)
// vim: sw=2 sts=2 et fdm=marker cms=\ //\ %s

#ifndef INIPHILE_INCLUDE_ERROR_HANDLER_HPP
#define INIPHILE_INCLUDE_ERROR_HANDLER_HPP

#include <algorithm>
#include <functional>
#include <boost/fusion/sequence/intrinsic/at_c.hpp>
#include <boost/fusion/include/at_c.hpp>
#include <boost/tuple/tuple.hpp>

namespace iniphile
{

template <class Iter>
struct error_handler
{
  template <class, class, class>
  struct result { typedef void type; };

  error_handler(Iter srcbeg, Iter srcend, std::ostream& erros)
  : erros(erros)
  , srcbeg(srcbeg)
  , srcend(srcend)
  {}

  template <class Args, class Context, class Rule>
  void operator()(Args const& args, Context const&, Rule const&) const
  {
    Iter const& err = boost::fusion::at_c<2>(args);
    boost::spirit::info const& what = boost::fusion::at_c<3>(args);

    Iter linebeg;
    int linenr;
    boost::tie(linebeg, linenr) = errline(err);

    erros
      << "error: expecting "
      << what
      << " on line "
      << linenr
      << ':'
      << std::endl
      << std::string(linebeg, std::find_if(linebeg, srcend, is_crlf()))
      << std::endl
      << std::string(std::distance(linebeg, err), ' ')
      << '^'
      << std::endl
    ;
  }

  boost::tuple<Iter, int>
  errline(Iter err) const
  {
    Iter linebeg = srcbeg;
    Iter i = srcbeg;
    int linenr = 1;

    while (i != err) {
      linebeg = i;
      i = std::find_if(i, err, is_crlf());
      if (i == err) break;
      ++linenr;
      i = std::find_if(i, err, std::not1(is_crlf()));
    }
    return boost::make_tuple(linebeg, linenr);
  }

  struct
  is_crlf
  {
    typedef char const argument_type;
    bool
    operator()(argument_type c) const
    {
      return c == '\r' || c == '\n';
    }
  };

  std::ostream& erros;
  Iter srcbeg;
  Iter srcend;
};

} // namespace iniphile

#endif // INIPHILE_INCLUDE_ERROR_HANDLER_HPP
