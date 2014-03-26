Contributing
============

You're encouraged to submit [pull requests](https://github.com/dblock/ARASCIISwizzle/pulls), [propose features and discuss issues](https://github.com/dblock/ARASCIISwizzle/issues).

#### Fork the Project

Fork the [project on Github](https://github.com/dblock/ARASCIISwizzle) and check out your copy.

```
git clone https://github.com/contributor/ARASCIISwizzle.git
cd ARASCIISwizzle
git remote add upstream https://github.com/dblock/ARASCIISwizzle.git
```

#### Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

#### Pod and Bundle Install

Install CocoaPods via Ruby Bundler.

```
bundle install
```

Install dependencies via CocoaPods,

```
pod install
```

#### Open Workspace

Open the ARASCIISwizzle.xcworkspace workspace in XCode.

#### Write Tests

There're two sets of tests: unit tests and integration tests. Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build.

We definitely appreciate pull requests that highlight or reproduce a problem, even without a fix. We don't accept pull requests without tests.

#### Write Code

Implement your feature or bug fix.

Make sure that you can build the project and run all tests successfully.

You may want to run tests on the command line.

```
brew install xctool
open -a iPhone\ Simulator
xctool -workspace ARASCIISwizzle.xcworkspace -scheme Demo -sdk iphonesimulator build test
xctool -workspace ARASCIISwizzle.xcworkspace -scheme Tests -sdk iphonesimulator build test
```

#### Write Documentation

Document any external behavior in the [README](README.md).

#### Update Changelog

Add a line to [CHANGELOG](CHANGELOG.md) under *Next Release*. Make it look like every other line, including your name and link to your Github account.

#### Commit Changes

Make sure git knows your name and email address:

```
git config --global user.name "Your Name"
git config --global user.email "contributor@example.com"
```

Writing good commit logs is important. A commit log should describe what changed and why.

```
git add ...
git commit
```

#### Push

```
git push origin my-feature-branch
```

#### Make a Pull Request

Go to https://github.com/contributor/ARASCIISwizzle and select your feature branch. Click the 'Pull Request' button and fill out the form. Pull requests are usually reviewed within a few days.

#### Rebase

If you've been working on a change for a while, rebase with upstream/master.

```
git fetch upstream
git rebase upstream/master
git push origin my-feature-branch -f
```

#### Update CHANGELOG Again

Update the [CHANGELOG](CHANGELOG.md) with the pull request number. A typical entry looks as follows.

```
* [#123](https://github.com/dblock/ARASCIISwizzle/pull/123): Reticulated splines - [@contributor](https://github.com/contributor).
```

Amend your previous commit and force push the changes.

```
git commit --amend
git push origin my-feature-branch -f
```

#### Check on Your Pull Request

Go back to your pull request after a few minutes and see whether it passed muster with Travis-CI. Everything should look green, otherwise fix issues and amend your commit as described above.

#### Be Patient

It's likely that your change will not be merged and that the nitpicky maintainers will ask you to do more, or fix seemingly benign problems. Hang on there!

#### Thank You

Please do know that we really appreciate and value your time and work. We love you, really.
