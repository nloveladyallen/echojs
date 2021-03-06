/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=4 sw=4 et tw=99 ft=cpp:
 */

#ifndef _ejs_uri_h
#define _ejs_uri_h

#include "ejs.h"
#include "ejs-object.h"

EJS_BEGIN_DECLS

extern ejsval _ejs_decodeURI;
extern ejsval _ejs_decodeURIComponent;
extern ejsval _ejs_encodeURI;
extern ejsval _ejs_encodeURIComponent;

extern EJS_NATIVE_FUNC(_ejs_decodeURI_impl);
extern EJS_NATIVE_FUNC(_ejs_decodeURIComponent_impl);
extern EJS_NATIVE_FUNC(_ejs_encodeURI_impl);
extern EJS_NATIVE_FUNC(_ejs_encodeURIComponent_impl);

void _ejs_uri_init (ejsval global);

EJS_END_DECLS

#endif
