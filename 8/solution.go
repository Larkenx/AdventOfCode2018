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

func getValue(node *Node) int {
	sum := 0
	if len(node.children) == 0 {
		for i := 0; i < len(node.metadata); i++ {
			sum += node.metadata[i]
		}
	} else {
		for i := 0; i < len(node.metadata); i++ {
			d := node.metadata[i]
			if d >= 1 && d <= len(node.children) {
				sum += getValue(node.children[d-1])
			}
		}
	}
	return sum
}

func processNode(data []int, index int, childAt int, parent *Node, thisIsRoot bool) int {
	childrenCount := data[index]
	metadataCount := data[index+1]
	childIndex := index + 2
	newNode := Node{children: make([]*Node, childrenCount), metadata: make([]int, metadataCount)}
	parent.children[childAt] = &newNode
	for i := 0; i < childrenCount; i++ {
		childIndex = processNode(data, childIndex, i, &newNode, false)
	}
	for j := 0; j < metadataCount; j++ {
		newNode.metadata[j] = data[childIndex]
		metadataSum += data[childIndex]
		childIndex += 1
	}
	return childIndex
}

func main() {
	b, err := ioutil.ReadFile("input.txt")
	if err != nil {
		fmt.Print(err)
	}
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
	childIndex := 2
	for i := 0; i < childrenCount; i++ {
		childIndex = processNode(data, childIndex, i, &tree, false)
	}
	for j := 0; j < metadataCount; j++ {
		tree.metadata[j] = data[childIndex]
		metadataSum += data[childIndex]
		childIndex += 1
	}
	fmt.Printf("The total metadata sum is: %d\n", metadataSum)
	fmt.Printf("The value of the root node is: %d\n", getValue(&tree))
}
