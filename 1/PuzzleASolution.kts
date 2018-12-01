import java.io.File
var frequencyData = File(System.getProperty("user.dir") + "/puzzle-a.txt")
var totalFrequency = frequencyData.readLines().map { line -> line.toInt() }.reduce { acc, it -> it + acc}
println(totalFrequency)