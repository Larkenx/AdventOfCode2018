package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type Node struct {
	children []*Node
	metadata []int
}

var metadataSum int = 0

func id(n int) string {
	alphabet := strings.Split("abcdefghijklmnopqrstuvwxyz", "")
	return alphabet[n]
}

func processNode(data []int, index int, childAt int, parent *Node, thisIsRoot bool) int {
	childrenCount := data[index]
	metadataCount := data[index+1]
	childIndex := index + 2
	thisNode := parent
	if !thisIsRoot {
		thisNode := Node{children: make([]*Node, childrenCount), metadata: make([]int, metadataCount)}
		t := &thisNode
		parent.children[childAt] = t
	}
	for i := 0; i < childrenCount; i++ {
		childIndex = processNode(data, childIndex, i, thisNode, false)
	}
	for j := 0; j < metadataCount; j++ {
		thisNode.metadata[j] = data[childIndex]
		metadataSum += data[childIndex]
		childIndex += 1
	}
	return childIndex
}

// https://stackoverflow.com/questions/36111777/golang-how-to-read-a-text-file
func main() {
	b, err := ioutil.ReadFile("input.txt")
	if err != nil {
		fmt.Print(err)
	}
	// https://stackoverflow.com/questions/16551354/how-to-split-a-string-and-assign-it-to-variables-in-golang
	input := strings.Split(string(b), " ")
	data := make([]int, len(input))
	for i := 0; i < len(input); i++ {
		data[i], err = strconv.Atoi(input[i])
		if err != nil {
			fmt.Println("uh oh")
		}
	}
	childrenCount := data[0]
	metadataCount := data[1]
	tree := Node{children: make([]*Node, childrenCount), metadata: make([]int, metadataCount)}
	t := &tree
	processNode(data, 0, 0, t, true)
	fmt.Printf("The total metadata sum is: %d\n", metadataSum)
	fmt.Println(tree)

}
