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
#include "libcef_dll/ctocpp/task_ctocpp.h"


// VIRTUAL METHODS - Body may be edited by hand.

void CefTaskCToCpp::Execute() {
  cef_task_t* _struct = GetStruct();
  if (CEF_MEMBER_MISSING(_struct, execute))
    return;

  // AUTO-GENERATED CONTENT - DELETE THIS COMMENT BEFORE MODIFYING

  // Execute
  _struct->execute(_struct);
}


// CONSTRUCTOR - Do not edit by hand.

CefTaskCToCpp::CefTaskCToCpp() {
}

template<> cef_task_t* CefCToCpp<CefTaskCToCpp, CefTask,
    cef_task_t>::UnwrapDerived(CefWrapperType type, CefTask* c) {
  NOTREACHED() << "Unexpected class type: " << type;
  return NULL;
}

#ifndef NDEBUG
template<> base::AtomicRefCount CefCToCpp<CefTaskCToCpp, CefTask,
    cef_task_t>::DebugObjCt = 0;
#endif

template<> CefWrapperType CefCToCpp<CefTaskCToCpp, CefTask,
    cef_task_t>::kWrapperType = WT_TASK;
#endif
