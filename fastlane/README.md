fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### build_ipa
```
fastlane build_ipa
```
Builds .ipa for project.

Parameters:

* **`build_number`**: Build number

* **`skip_cocoapods`**: Should Cocoa Pods install be skipped?. (`DL_SKIP_COCOAPODS`)
### ui_tests
```
fastlane ui_tests
```
Run UI tests
### unit_tests
```
fastlane unit_tests
```
Run Unit tests
### publish_to_staging
```
fastlane publish_to_staging
```
Publishes produced .ipa to staging

Parameters:

* **`release_notes`**: Release notes.
### build_pod_static_lib
```
fastlane build_pod_static_lib
```
Builds static library, documentation, podspec and changelog and put it in one directory.

Parameters:

* **`version`**: Version number. If not specified script looks for it in VERSION file.

* **`project_name`**: Name of the project. (`DL_PROJECT_NAME`)

* **`scheme`**: XCode scheme of universal library. (`DL_BUILD_SCHEME`)

* **`build_output_path`**: Path to output directory. (`DL_BUILD_OUTPUT_PATH`)
### publish_pod_static_lib
```
fastlane publish_pod_static_lib
```
Publish Cocoapod that is distributed as static library.

Parameters:

* **`project_name`**: Name of the project. (`PROJECT_NAME`)

* **`output_git_repo_path`**: Local path where remote repository will be cloned. Default value is build/remote. (`DL_OUTPUT_GIT_REPO_PATH`)

* **`output_git_repo_url`**: Repository where new version of the library should be pushed. (`DL_OUTPUT_GIT_REPO_URL`)

* **`specs_repository`**: DreamLab podspecs repository identifier. Values: public|private. (`DL_OUTPUT_SPEC_REPOSITORY`)

* **`build_output_path`**: Path to directory whith output of `build_pod` lane. (`DL_BUILD_OUTPUT_PATH`)
### publish_pod_source
```
fastlane publish_pod_source
```
Publish Cocoapod that is distributed as source code.

Parameters:

* **`project_name`**: Name of the project. (`DL_PROJECT_NAME`)

* **`specs_repository`**: DreamLab podspecs repository identifier. Values: public|private. (`DL_OUTPUT_SPEC_REPOSITORY`)
### build_documentation
```
fastlane build_documentation
```
Build Documentation

* **`output_dir`**: Path to output directory.
### init_env
```
fastlane init_env
```
Initialize environment for building.

It fetch the .env.default file.

----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools).
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).