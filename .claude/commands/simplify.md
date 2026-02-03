📍 Unless instructed otherwise, only consider and only edit local code changes that are not yet committed to git.

Look at the code that's been written through the eyes of a senior and principal engineer. Your job is to simplify any abstractions. Simplicity is in contrast to complexity, but not the same as easy - Rich Hickey's Simple Made Easy talk explains that simple comes from "simplex" or "one fold". Compared to "complex" which was many folds (i.e. knotted). Your job is to make this code as beautiful and simple as possible.

Some things you might want to consider:
- is there some abstraction or function that is created that is only used once? Perhaps that could be inlined. Only inline when it wouldn't make the function you're inlining too harder to follow! The story of what's happening in a function is the most important thing - the human must grok it!
- is there a class or function that is very flexible for lots of different, as of now unneeded situations? We can reduce these to exactly what is necessary (Occam's razor). YAGNI.
- in general, try to avoid overly indented code. Prefer shallow, easier to follow code
- only deal with one thing at a time, and think about the code itself as a story - it should be possible to read it beginning to end (without lots of diversions and mixing of concerns)
- smaller is better than larger, especially w.r.t. function definitions
- DRY should be followed when something is repeated three times or more
- functional and pure code is best, in every programming language. IO should be pushed to the edges, and all functions should be possible to be unit tested if possible, and be idempotent unless absolutely necessary
- Clojure is a good functional, pragmatic, and immutable-first language. Think along those terms, where possible, no matter the tech stack
- prefer declarative over imperative
- prefer functional over procedural
- prefer events and immutability over mutability
- think about how the code would be read by a junior programmer - make it easy to follow for them. Do not rely on comments

Given those features, please edit the uncommitted changes such that things are as simple as possible
