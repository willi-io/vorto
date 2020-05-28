/**
 * Copyright (c) 2020 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * https://www.eclipse.org/legal/epl-2.0
 *
 * SPDX-License-Identifier: EPL-2.0
 */
package org.eclipse.vorto.codegen.hono.python

import org.eclipse.vorto.core.api.model.functionblock.FunctionblockModel
import org.eclipse.vorto.plugin.generator.InvocationContext
import org.eclipse.vorto.plugin.generator.utils.IFileTemplate

class PythonFbTemplate implements IFileTemplate<FunctionblockModel> {
	
	override getFileName(FunctionblockModel fb) {
		return fb.name + ".py";
	}
	
	override getPath(FunctionblockModel fb) {
		return "model/functionblock";
	}
	
	override getContent(FunctionblockModel fb, InvocationContext context) {
		'''
		# // Generated by Vorto from «fb.namespace».«fb.name»
		
		class «fb.name»(object):
		    def __init__(self):
		        «IF fb.functionblock.status !== null»
		        	«FOR prop : fb.functionblock.status.properties»
		        	self.«prop.name» = 0.0
		        	«ENDFOR»
		        «ENDIF»
		        «IF fb.functionblock.configuration !== null»
		        	«FOR prop : fb.functionblock.configuration.properties»
		        	self.«prop.name» = 0.0
		        	«ENDFOR»
		        «ENDIF»
		
		    «IF fb.functionblock.status !== null»
		    	«FOR prop : fb.functionblock.status.properties»
		    		### Status property «prop.name»
		    		@property
		    		def «prop.name»(self):
		    		    return self.__«prop.name»[0]
		    		
		    		@«prop.name».setter
		    		def «prop.name»(self, value):
		    		    self.__«prop.name» = (value, True)
		    		
		    	«ENDFOR»
		    «ENDIF»
		    «IF fb.functionblock.configuration !== null»
		    	«FOR prop : fb.functionblock.configuration.properties»
		    		### Configuration property «prop.name»
		    		@property
		    		def «prop.name»(self):
		    		    return self.__«prop.name»[0]
		    		
		    		@«prop.name».setter
		    		def «prop.name»(self, value):
		    		    self.__«prop.name» = (value, True)
		    		
		    	«ENDFOR»
		    «ENDIF»
		    def serializeStatus(self, serializer):
		        «IF fb.functionblock.status !== null»
		        	serializer.first_prop = True
		        	«FOR prop : fb.functionblock.status.properties»
		        	if self.__«prop.name»[1]:
		        	       serializer.serialize_property("«prop.name»", self.__«prop.name»[0])
		        	       self.__«prop.name» = (self.__«prop.name»[0], False)
		        	«ENDFOR»
		        «ELSE»
		        pass
		        «ENDIF»
		    def serializeConfiguration(self, serializer):
		        «IF fb.functionblock.configuration !== null»
		        	serializer.first_prop = True
		        	«FOR prop : fb.functionblock.configuration.properties»
		        	if self.__«prop.name»[1]:
		        	       serializer.serialize_property("«prop.name»", self.__«prop.name»[0])
		        	       self.__«prop.name» = (self.__«prop.name»[0], False)
		        	«ENDFOR»
		        «ELSE»
		        pass
		        «ENDIF»
		'''
	}
	
}