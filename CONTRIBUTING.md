The following rules generally apply for PRs and code changes:

**Submit Pull Requests to the `develop` branch**

This is where all experimental and other beta-ish features will go. 
`develop` will collect many new features until a release is planned. At a point where a stable release is ready, 
`develop` branch will then be merged into `master` and a release tag will be generated for the general public.

**Markdown documentation and header-level comment changes need to run Jazzy**

If making a change to the documentation or changes inside of method/property quick look comments,
[Jazzy](https://github.com/realm/jazzy) needs to be run. Please install Jazzy and run the following
Terminal command from the Supporting/jazzy directory: 

`./generate_docs.sh`

**Blend with existing patterns**

If, for instance, you are contributing by adding another 
[Closure API](https://github.com/vhesener/Closures/issues?q=is%3Aissue+is%3Aopen+label%3A%22Closure+API+Request%22)
and that API has a precedent for implementation, it is best to mimic the existing precedent's pattern.
If however, you think both the new API and it's counterparts could use improvements, let's definitely
discuss how to update all of the existing APIs as well. 

Let's take a simple example of adding a new API for a delegate protocol. The following is almost universal:

- [x] Use the Delegate/Delegator wrapper mechanism used by other delegate APIs
- [x] Unit tests to make sure all delegate methods are covered
- [x] Documentation on any public initializers, methods, or properties
- [x] Playground example showing how to use it, along with explanations
