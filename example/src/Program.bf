using System;
using System.Collections;
using System.Diagnostics;
using System.IO;

using static jsmn_Beef.jsmn;

namespace example;

static class Program
{
	static void* realloc(void* ptr, uint size)
	{
		void* newptr;
		int msize = 0;

		newptr = Internal.StdMalloc((.)size);
		Internal.MemCpy(newptr, ptr, msize);
		Internal.Free(ptr);
		return newptr;
	}

	/* Function realloc_it() is a wrapper function for standard realloc()
	 * with one difference - it frees old memory pointer in case of realloc
	 * failure. Thus, DO NOT use old data pointer in anyway after call to
	 * realloc_it(). If your code has some kind of fallback algorithm if
	 * memory can't be re-allocated - use standard realloc() instead.
	 */
	static void* realloc_it(void* ptrmem, uint size)
	{
		void* p = realloc(ptrmem, size);
		if (p == null)
		{
			Internal.Free(ptrmem);
			//fDebug.WriteLine(stderr, "realloc(): errno=%d\n", errno);
		}
		return p;
	}

	/*
	 * An example of reading JSON from stdin and printing its content to stdout.
	 * The output looks like YAML, but I'm not sure if it's really compatible.
	 */

	static int dump(char8* js, jsmntok* t, int count, int indent)
	{
		int i, j, k;
		jsmntok* key;
		if (count == 0)
		{
			return 0;
		}
		if (t.type == .JSMN_PRIMITIVE)
		{
			//Debug.WriteLine("%.*s", t.end - t.start, js + t.start);
			return 1;
		} else if (t.type == .JSMN_STRING)
		{
			// Debug.WriteLine("'%.*s'", t.end - t.start, js + t.start);
			return 1;
		} else if (t.type == .JSMN_OBJECT)
		{
			//Debug.WriteLine("\n");
			j = 0;
			for (i = 0; i < t.size; i++)
			{
				for (k = 0; k < indent; k++)
				{
					Debug.WriteLine("  ");
				}
				key = t + 1 + j;
				j += dump(js, key, count - j, indent + 1);
				if (key.size > 0)
				{
					Debug.WriteLine(": ");
					j += dump(js, t + 1 + j, count - j, indent + 1);
				}
				Debug.WriteLine("\n");
			}
			return j + 1;
		} else if (t.type == .JSMN_ARRAY)
		{
			j = 0;
			Debug.WriteLine("\n");
			for (i = 0; i < t.size; i++)
			{
				for (k = 0; k < indent - 1; k++)
				{
					Debug.WriteLine("  ");
				}
				Debug.WriteLine("   - ");
				j += dump(js, t + 1 + j, count - j, indent + 1);
				Debug.WriteLine("\n");
			}
			return j + 1;
		}
		return 0;
	}

	static int Main(params String[] args)
	{
		int r;
		int eof_expected = 0;
		char8* js = null;
		int jslen = 0;
		char8[512] buf;

		jsmn_parser p;
		jsmntok* tok = null;
		int tokcount = 2;

		/* Prepare parser */
		jsmn_init(&p);

		return 0;
	}
}