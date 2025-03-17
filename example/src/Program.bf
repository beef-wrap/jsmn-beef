using System;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Interop;

using static jsmn.jsmn;

namespace example;

static class Program
{
	const String JSON_STRING = """
		{
			"user": "johndoe", 
			"admin": false, 
			"uid": 1000",
			"groups": ["users", "wheel", "audio", "video"]
		}
	""";

	[CLink] public static extern int strncmp(c_char* str1, c_char* str2, uint n);
	[CLink] public static extern uint strlen(c_char* str);

	static int jsoneq(String json, jsmntok* tok, c_char* s)
	{
		if (
			tok.type == jsmntype.JSMN_STRING &&
			scope String(s).Length == tok.end - tok.start &&
			strncmp(json.CStr() + tok.start, s, (.)(tok.end - tok.start)) == 0)
		{
			return 0;
		}
		return -1;
	}

	static StringView extract(String json, jsmntok* tok)
	{
		return StringView(json, tok.start, tok.end - tok.start);
	}

	static int Main(params String[] args)
	{
		int r;
		jsmn_parser p;
		jsmntok[128] t = .(); /* We expect no more than 128 tokens */

		jsmn_init(&p);
		r = jsmn_parse(&p, JSON_STRING, (.)scope String(JSON_STRING).Length, &t, 128);

		if (r < 0)
		{
			Debug.WriteLine("Failed to parse JSON: {r}");
			return 1;
		}

		/* Assume the top-level element is an object */
		if (r < 1 || t[0].type != jsmntype.JSMN_OBJECT)
		{
			Debug.WriteLine("Object expected");
			return 1;
		}

		/* Loop over all keys of the root object */
		for (var i < r)
		{
			if (jsoneq(JSON_STRING, &t[i], "user") == 0)
			{
				Debug.WriteLine($"- User: {extract(JSON_STRING, &t[i + 1])}");
				i++;
			} else if (jsoneq(JSON_STRING, &t[i], "admin") == 0)
			{
				Debug.WriteLine($"- Admin: {extract(JSON_STRING, &t[i + 1])}");
				i++;
			} else if (jsoneq(JSON_STRING, &t[i], "uid") == 0)
			{
				Debug.WriteLine($"- UID: {extract(JSON_STRING, &t[i + 1])}");
				i++;
			} else if (jsoneq(JSON_STRING, &t[i], "groups") == 0)
			{
				int j;
				Debug.WriteLine("- Groups:");
				if (t[i + 1].type != jsmntype.JSMN_ARRAY)
				{
					continue; /* We expect groups to be an array of strings */
				}
				for (j = 0; j < t[i + 1].size; j++)
				{
					jsmntok* g = &t[i + j + 2];
					Debug.WriteLine($"* {extract(JSON_STRING, g)}");
				}
				i += t[i + 1].size + 1;
			}
		}

		return 0;
	}
}