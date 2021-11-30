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

val sireum = Os.path(Os.env("SIREUM_HOME").get) / "bin" / "sireum"
val nodejs = Os.home / "etc/nodejs/node-v16.13.0-linux-x64/bin/node"

assert(nodejs.exists, "Point to your nodejs install location")

val home = Os.slashDir.up

val libsDir= home / "lib"
libsDir.mkdir()

val jsOutputDir = home / "js"
jsOutputDir.mkdir()

def download(url: String): Os.Path = {
  val p = Os.path(url)
  val dest = libsDir / p.name
  if(!dest.exists){
    dest.downloadFrom(url)
  }
  assert(dest.exists)
  return dest
}

//val runtimes = download("https://jitpack.io/com/github/sireum/kekinian/library-shared_sjs1_2.13/4.20211103.09b1e32/library-shared_sjs1_2.13-4.20211103.09b1e32.jar")
val runtimejs = Os.home / ".m2/repository/org/sireum/kekinian/library-shared_sjs1_2.13/20211129.1337.bbe6019/library-shared_sjs1_2.13-20211129.1337.bbe6019.jar"

//val macrosjs = download("https://jitpack.io/com/github/sireum/kekinian/macros_sjs1_2.13/4.20211103.09b1e32/macros_sjs1_2.13-4.20211103.09b1e32.jar")
val macrosjs = Os.home / ".m2/repository/org/sireum/kekinian/macros_sjs1_2.13/20211129.1337.bbe6019/macros_sjs1_2.13-20211129.1337.bbe6019.jar"

val scalajslib = download("https://oss.sonatype.org/content/repositories/releases/org/scala-js/scalajs-library_2.13/1.7.1/scalajs-library_2.13-1.7.1.jar")

for(p <- ISZ(runtimejs, macrosjs, scalajslib) if !p.exists) {
  halt(s"${p} doesn't exist")
}

// got the following from https://www.scala-js.org/files/scalajs_2.13-1.7.1.tgz
val scalajsAssembly = Os.home / "temp/scalajs/scalajs_2.13-1.7.1/lib/scalajs-cli-assembly_2.13-1.7.1.jar"
assert(scalajsAssembly.exists, "Point to your scalajs standalone cli jar")

val envs: ISZ[(String, String)] = ISZ(("TARGETING_JS", "true")) // change components, bridged, etc into shared projects
proc"${sireum.string} proyek tipe --par ${home.value}".env(envs).console.runCheck()

println("Proyek JS compiling project ...")
proc"${sireum.string} proyek compile --par --js ${home.value}".env(envs).console.runCheck()

val slang_js = home / "out" / "test-js"
val proyek_json = slang_js / "proyek.json"

assert(proyek_json.exists, s"${proyek_json} not found")

val project: Project = JSON.toProject(proyek_json.read) match {
  case Either.Left(u) => u
  case Either.Right(e) => halt(e.string)
}


var cps: ISZ[String] = ISZ()
for(m <- project.modules.values){
  if(ops.ISZOps(m.targets).contains(Target.Js)){
    val classes = slang_js / "modules" / m.id / "classes"
    if(!classes.exists) {
      halt(s"classes directory not found for JS module ${m.id}")
    }
    cps = cps :+ classes.canon.value
  }
}

val s = st"scala -classpath ${scalajsAssembly.value} org.scalajs.cli.Scalajsld --stdlib ${scalajslib.value} --mainMethod test.Test.main --outputDir ${jsOutputDir.value} ${macrosjs.value} ${runtimejs.value} ${(cps, " ")}"

println("Running scalaJS linker")
proc"${s.render}".at(home).env(envs).console.runCheck()

val mainjs = jsOutputDir / "main.js"

println("Running app using nodejs")
proc"${nodejs.value} ${mainjs.value}".console.runCheck()
