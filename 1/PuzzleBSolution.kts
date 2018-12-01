import java.io.File
val frequencyData = File(System.getProperty("user.dir") + "/puzzle-a.txt")
val seenFrequencies: HashSet<Int> = hashSetOf()
val frequencyChangeList = frequencyData.readLines().map { line -> line.toInt() }
var iter = frequencyChangeList.iterator()
var currentFrequency = 0
do {
    seenFrequencies.add(currentFrequency)
    if (!iter.hasNext()) iter = frequencyChangeList.iterator()
    currentFrequency += iter.next()
} while (!seenFrequencies.contains(currentFrequency))
print(currentFrequency)

