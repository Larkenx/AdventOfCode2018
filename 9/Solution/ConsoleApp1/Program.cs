using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace Solution
{
    class Solution
    {

        public class Node
        {
            public Node prev;
            public Node next;
            public long val;

            public Node(long val)
            {
                this.val = val;
                this.next = this;
                this.prev = this;
            }

            public Node AddBefore(Node node)
            {
                node.prev = this.prev;
                node.next = this;
                this.prev.next = node;
                this.prev = node;
                return node;
            }

            public Node AddAfter(Node node)
            {
                node.next = this.next;
                node.prev = this;
                this.next.prev = node;
                this.next = node;
                return node;
            }

            public Node DeleteNext() {
                this.next.next.prev = this;
                this.next = this.next.next;
                return this;
            }

            public void PrintLinkedList(int iterations)
            {
                Node current = this;
                String result = "";
                for (int i = 0; i <= iterations; i++)
                {
                    if (current.val == iterations)
                    {
                        result += String.Format("({0}) ", current.val.ToString());
                    } else
                    {
                        result += current.val.ToString() + " ";
                    }
                    current = current.next;
                }
                Console.WriteLine(result);
            }

            public Node Rotate(int n)
            {
                Node result = this;
                bool clockwise = n > 0;
               // String rotationString = String.Format(" ({0}) ", result.val.ToString());
                for (int i = 0; i < Math.Abs(n); i++)

                {
                    if (clockwise)
                    {
                        result = result.next;
                      //  rotationString = rotationString + String.Format("{0}{1}", " => ", result.val);
                    } else
                    {
                        result = result.prev;
                       // rotationString = String.Format("{0}{1}", " <= ", result.val) + rotationString;
                    }
                }
              //  Console.WriteLine("Rotating: " + rotationString);
                return result;
            }

        }


        static Node Turn(Node game, long currentMarble)
        {
            return game.AddAfter(new Node(currentMarble)).next;
        }

        static Node TurnSpecial(Node game, long currentMarble, long currentPlayer, long[] scores)
        {
            scores[currentPlayer] += currentMarble;
            scores[currentPlayer] += game.Rotate(-8).val;
            return game.Rotate(-9).DeleteNext().next.next;
        }


        static void Main(string[] args)
        {
            Regex rx = new Regex(@"(?<playerCount>\d+) players; last marble is worth (?<numberOfMarbles>\d+).*");
            string input = System.IO.File.ReadAllText(@"C:\Users\Larken\git\AdventOfCode2018\9\c-sharp\Solution\input.txt");
            MatchCollection matches = rx.Matches(input);
            GroupCollection groups = matches[0].Groups;
            long playerCount = Convert.ToInt64(groups["playerCount"].Value);
            long numberOfMarbles = Convert.ToInt64(groups["numberOfMarbles"].Value) * 100;
            long[] scores = new long[playerCount];
            Node marbles = new Node(0);
            Node result = marbles.next;
            long currentPlayer = 0;
            for (long currentMarble = 1; currentMarble <= numberOfMarbles; currentMarble++)
            {

                if (currentMarble % 23 == 0)
                {
                    result = TurnSpecial(result, currentMarble, currentPlayer, scores);
                } else
                {
                    result = Turn(result, currentMarble);
                }
                if (currentPlayer == playerCount - 1)
                {
                    currentPlayer = 0;
                } else
                {
                    currentPlayer++;
                }
                // marbles.PrintLinkedList(currentMarble);
            }
            String gameBreakdown = "";
            for (int i = 0; i< scores.Length; i++)
            {
                gameBreakdown += String.Format("Player {0} scored {1} points!\n", i + 1, scores[i]);
            }
            Console.WriteLine(gameBreakdown);
            Console.WriteLine("Biggest score was: " + scores.Max());
        }
    }
}
