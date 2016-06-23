import random
import sys

FACES = [1, 2, 3, 4, 5, 6]

SHOW_ROLLS = True
DEBUG = False


def roll(attack_dice, defend_dice):
    """Input: number of dice the attacker rolls, number of dice the defender rolls

    Output: tuple, (number of dead attacking armies, number of dead defender armies)"""
    attack_rolls = sorted([random.choice(FACES) for i in range(attack_dice)], reverse=True)
    defend_rolls = sorted([random.choice(FACES) for i in range(defend_dice)], reverse=True)
    if SHOW_ROLLS:
        print("Attacker rolls {}, defender rolls {}".format(attack_rolls, defend_rolls))
    attacker_deaths = 0
    defender_deaths = 0
    for i in range(len(defend_rolls)):
        if attack_rolls[i] > defend_rolls[i]:
            defender_deaths += 1
        else:
            attacker_deaths += 1
    if DEBUG:
        print("Attacker deaths, defender deaths: {}".format((attacker_deaths, defender_deaths)))
    return (attacker_deaths, defender_deaths)


def attack(attack_armies, defend_armies):
    """Input: number of armies on the attacking country, number of armies on the defending country.
    Output: number of armies on the attacking country, number of armies on the defending country after a single attack round."""
    if attack_armies == 1:
        # NOT A VALID ATTACK
        return (attack_armies, defend_armies)
    attack_dice = 1
    if attack_armies == 3:
        attack_dice = 2
    elif attack_armies > 3:
        attack_dice = 3
    defend_dice = 1
    if defend_armies > 1:
        defend_dice = 2
    deaths = roll(attack_dice, defend_dice)
    if DEBUG:
        print("after attack: {}".format((attack_armies - deaths[0], defend_armies - deaths[1])))
    return (attack_armies - deaths[0], defend_armies - deaths[1])


def attack_as_long_as_possible(attack_armies, defend_armies):
    """Input: number of armies on the attacking country, number of armies on the defending country.
    Output: number of armies on the attacking country, number of armies on the defending country after either the attacker has lost all but one army or the defender is wiped out."""
    while attack_armies > 1 and defend_armies > 0:
        attack_armies, defend_armies = attack(attack_armies, defend_armies)
        if DEBUG:
            print("After round: {}".format((attack_armies, defend_armies)))
    return (attack_armies, defend_armies)

if __name__ == '__main__':
    attack_armies = int(sys.argv[1])
    defend_armies = int(sys.argv[2])
    attack_armies, defend_armies = attack_as_long_as_possible(attack_armies, defend_armies)
    if attack_armies > 1:
        print("Attacker wins! {} armies are still alive!".format(attack_armies))
    else:
        print("Defender wins! attacker down to {}, {} defender armies are still alive!".format(attack_armies, defend_armies))
