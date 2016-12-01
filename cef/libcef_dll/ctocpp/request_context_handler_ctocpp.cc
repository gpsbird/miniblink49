// Copyright (c) 2016 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.
//
// ---------------------------------------------------------------------------
//
// This file was generated by the CEF translator tool. If making changes by
// hand only do so within the body of existing method and function
// implementations. See the translator.README.txt file in the tools directory
// for more information.
//
#if (defined ENABLE_CEF) && (ENABLE_CEF == 1)
#include "libcef_dll/cpptoc/cookie_manager_cpptoc.h"
#include "libcef_dll/cpptoc/web_plugin_info_cpptoc.h"
#include "libcef_dll/ctocpp/request_context_handler_ctocpp.h"


// VIRTUAL METHODS - Body may be edited by hand.

CefRefPtr<CefCookieManager> CefRequestContextHandlerCToCpp::GetCookieManager() {
  cef_request_context_handler_t* _struct = GetStruct();
  if (CEF_MEMBER_MISSING(_struct, get_cookie_manager))
    return NULL;

  // AUTO-GENERATED CONTENT - DELETE THIS COMMENT BEFORE MODIFYING

  // Execute
  cef_cookie_manager_t* _retval = _struct->get_cookie_manager(_struct);

  // Return type: refptr_diff
  return CefCookieManagerCppToC::Unwrap(_retval);
}

bool CefRequestContextHandlerCToCpp::OnBeforePluginLoad(
    const CefString& mime_type, const CefString& plugin_url,
    const CefString& top_origin_url, CefRefPtr<CefWebPluginInfo> plugin_info,
    PluginPolicy* plugin_policy) {
  cef_request_context_handler_t* _struct = GetStruct();
  if (CEF_MEMBER_MISSING(_struct, on_before_plugin_load))
    return false;

  // AUTO-GENERATED CONTENT - DELETE THIS COMMENT BEFORE MODIFYING

  // Verify param: mime_type; type: string_byref_const
  DCHECK(!mime_type.empty());
  if (mime_type.empty())
    return false;
  // Verify param: plugin_info; type: refptr_diff
  DCHECK(plugin_info.get());
  if (!plugin_info.get())
    return false;
  // Verify param: plugin_policy; type: simple_byaddr
  DCHECK(plugin_policy);
  if (!plugin_policy)
    return false;
  // Unverified params: plugin_url, top_origin_url

  // Execute
  int _retval = _struct->on_before_plugin_load(_struct,
      mime_type.GetStruct(),
      plugin_url.GetStruct(),
      top_origin_url.GetStruct(),
      CefWebPluginInfoCppToC::Wrap(plugin_info),
      plugin_policy);

  // Return type: bool
  return _retval?true:false;
}


// CONSTRUCTOR - Do not edit by hand.

CefRequestContextHandlerCToCpp::CefRequestContextHandlerCToCpp() {
}

template<> cef_request_context_handler_t* CefCToCpp<CefRequestContextHandlerCToCpp,
    CefRequestContextHandler, cef_request_context_handler_t>::UnwrapDerived(
    CefWrapperType type, CefRequestContextHandler* c) {
  NOTREACHED() << "Unexpected class type: " << type;
  return NULL;
}

#ifndef NDEBUG
template<> base::AtomicRefCount CefCToCpp<CefRequestContextHandlerCToCpp,
    CefRequestContextHandler, cef_request_context_handler_t>::DebugObjCt = 0;
#endif

template<> CefWrapperType CefCToCpp<CefRequestContextHandlerCToCpp,
    CefRequestContextHandler, cef_request_context_handler_t>::kWrapperType =
    WT_REQUEST_CONTEXT_HANDLER;
#endif
