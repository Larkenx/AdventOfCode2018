import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class Solution {

    public static void solveA() throws Exception {
        Path path = Paths.get("input.txt");
        List<String> claims = Files.readAllLines(path);
        HashMap<String, Integer> histogram = new HashMap<>();
        HashMap<String, List<String>> claimsKeys = new HashMap<>();
        String claimIdWithNoOverlaps = "none";
        // #1 @ 37,526: 17x23
        Pattern p = Pattern.compile("#(?<claimId>\\d*)\\s@\\s(?<x>\\d+),(?<y>\\d+):\\s(?<width>\\d+)x(?<height>\\d+)");
        for (String claim : claims) {           
            Matcher matcher = p.matcher(claim);
            matcher.find();
            String claimId = matcher.group("claimId");
            claimsKeys.put(claimId, new ArrayList<>());
            int startX = Integer.parseInt(matcher.group("x"));
            int startY = Integer.parseInt(matcher.group("y"));
            int width = Integer.parseInt(matcher.group("width"));
            int height = Integer.parseInt(matcher.group("height"));
            for (int y = startY; y < startY + height; y++) {
                for (int x = startX; x < startX + width; x++) {
                    String key = x + "," + y;
                    claimsKeys.get(claimId).add(key);
                    int occurrences = histogram.getOrDefault(key, 0);
                    histogram.put(key, occurrences + 1);
                }
            }
        }

        int inchesOfOverlappingFabric = 0;
        for (Map.Entry<String, Integer> entry : histogram.entrySet()) {
            if (entry.getValue() >= 2)
                inchesOfOverlappingFabric++;
        }
        System.out.printf("%d inches of fabric are overlapping at least 2 claims!\n", inchesOfOverlappingFabric);
        for (Map.Entry<String, List<String>> entry : claimsKeys.entrySet()) {
            boolean doesNotOverlap = true;
            for (String key : entry.getValue()) doesNotOverlap = doesNotOverlap && histogram.get(key) == 1;
            if (doesNotOverlap) System.out.printf("%s is the only claim that does not overlap", entry.getKey());
        }
    }

    public static void main(String[] args) {
        try {
            Solution.solveA();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
