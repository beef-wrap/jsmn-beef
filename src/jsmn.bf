/*
 * MIT License
 *
 * Copyright (c) 2010 Serge Zaitsev
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


using System;
using System.Interop;

namespace jsmn;

public static class jsmn
{
	/**
	* JSON type identifier. Basic types are:
	* 	o Object
	* 	o Array
	* 	o String
	* 	o Other primitive: number, boolean (true/false) or null
	*/
	public enum jsmntype : c_int
	{
		JSMN_UNDEFINED = 0,
		JSMN_OBJECT = 1 << 0,
		JSMN_ARRAY = 1 << 1,
		JSMN_STRING = 1 << 2,
		JSMN_PRIMITIVE = 1 << 3
	}

	public enum jsmnerr : c_int
	{
		/* Not enough tokens were provided */
		JSMN_ERROR_NOMEM = -1,
		/* Invalid character inside JSON string */
		JSMN_ERROR_INVAL = -2,
		/* The string is not a full JSON packet, more bytes expected */
		JSMN_ERROR_PART = -3
	}

	/**
	* JSON token description.
	* type		type (object, array, string etc.)
	* start		start position in JSON data string
	* end		end position in JSON data string
	*/
	[CRepr] public struct jsmntok
	{
		public jsmntype type;
		public c_int start;
		public c_int end;
		public c_int size;
		// #ifdef JSMN_PARENT_LINKS
		//   int parent;
		// #endif
	}

	/**
	* JSON parser. Contains an array of token blocks available. Also stores
	* the string being parsed now and current position in that string.
	*/
	[CRepr] public struct jsmn_parser
	{
		c_uint pos; /* offset in the JSON string */
		c_uint toknext; /* next token to allocate */
		c_int toksuper; /* superior token node, e.g. parent object or array */
	}

	/**
	* Create JSON parser over an array of tokens
	*/
	[CLink] public static extern void jsmn_init(jsmn_parser* parser);

	/**
	* Run JSON parser. It parses a JSON data string into and array of tokens, each
	* describing
	* a single JSON object.
	*/
	[CLink] public static extern c_int jsmn_parse(jsmn_parser* parser, c_char* js, c_uint len, jsmntok* tokens, c_uint num_tokens);
}