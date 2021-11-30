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

