::#! 2> /dev/null                                   #
@ 2>/dev/null # 2>nul & echo off & goto BOF         #
if [ -z ${SIREUM_HOME} ]; then                      #
  echo "Please set SIREUM_HOME env var"             #
  exit -1                                           #
fi                                                  #
exec ${SIREUM_HOME}/bin/sireum slang run "$0" "$@"  #
:BOF
setlocal
if not defined SIREUM_HOME (
  echo Please set SIREUM_HOME env var
  exit /B -1
)
%SIREUM_HOME%\\bin\\sireum.bat slang run "%0" %*
exit /B %errorlevel%
::!#
// #Sireum

// Example Sireum Proyek build definitions -- the contents of this file will not be overwritten
//
// To install Sireum (Proyek and IVE) see https://github.com/sireum/kekinian#installing
//
// The following commands should be executed in the parent of the 'bin' directory.
//
// Command Line:
//   To run the demo from the command line using the default scheduler:
//     sireum proyek run . isolette__JVM.Demo
//
//   To see the available CLI options:
//     sireum proyek run . isolette__JVM.Demo -h
//
//   To run the example unit tests from the command line:
//     sireum proyek test .
//
//   To build an executable jar:
//     sireum proyek assemble --uber --main isolette__JVM.Demo .
//
// Sireum IVE:
//
//   If you did not have HAMR run Proyek IVE then first generate the IVE project:
//     sireum proyek ive .
//
//   Then in IVE select 'File > Open ...' and navigate to the parent of the
//   'bin' directory and click 'OK'.
//
//   To run the demo from within Sireum IVE:
//     Right click src/main/architecture/isolette__JVM/Demo.scala and choose "Run 'Demo'"
//
//   To run the unit test cases from within Sireum IVE:
//     Right click the src/test/bridge and choose "Run ScalaTests in bridge"
//
//   NOTE: A ClassNotFoundException may be raised the first time you try to
//         run the demo or unit tests.  If this occurs simply delete the directory
//         named 'target' and retry

import org.sireum._
import org.sireum.project.{JSON, Module, Project, ProjectUtil, Target}

def usage(): Unit = {
  println("Usage: [ json ]")
}

var isDot = T

Os.cliArgs match {
  case ISZ(string"json") => isDot = F
  case ISZ(string"-h") =>
    usage()
    Os.exit(0)
  case ISZ() =>
  case _ =>
    usage()
    Os.exit(-1)
}

val homeDir: Os.Path = Os.slashDir.up.canon

val runtime: String =  "org.sireum.kekinian::library:"
val runtimeShared: String = "org.sireum.kekinian::library-shared:"
val macroShared: String = "org.sireum.kekinian::macros:"

val jvmTarget: ISZ[Target.Type] = ISZ(Target.Jvm)
val jvmLibrary: ISZ[String] = ISZ(macroShared, runtime)

val sharedTarget: ISZ[Target.Type] = Module.allTargets
val sharedLibrary: ISZ[String] = ISZ(macroShared, runtimeShared)


val targetingScalaJS = T//F || Os.envs.contains("TARGETING_JS")

def module(id: String,
           baseDir: Os.Path,
           subPathOpt: Option[String],
           deps: ISZ[String],
           targets: ISZ[Target.Type],
           ivyDeps: ISZ[String],
           sources: ISZ[String],
           testSources: ISZ[String]): Module = {
  return Module(
    id = id,
    basePath = baseDir.string,
    subPathOpt = subPathOpt,
    deps = deps,
    targets = targets,
    ivyDeps = ivyDeps,
    resources = ISZ(),
    sources = sources,
    testSources = testSources,
    testResources = ISZ(),
    publishInfoOpt = None()
  )
}

//user
val demoJS: Module = module(
  id = "demoJS",
  baseDir = homeDir / "src" / "demoJS",
  subPathOpt = None(),
  deps = ISZ(),
  targets = sharedTarget,
  ivyDeps = sharedLibrary,
  sources = ISZ("main"),
  testSources = ISZ())

var slangProject: Project = Project.empty + demoJS

val project: Project = slangProject

if (isDot) {
  val projectDot = homeDir / "project.dot"
  projectDot.writeOver(ProjectUtil.toDot(project))
  println(s"Wrote $projectDot")
} else {
  println(JSON.fromProject(project, T))
}

