#define MASK_SIZE_ 500
int mask_[MASK_SIZE_] = {
 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0,
 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,
 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0,
 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0,
 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0,
 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0,
 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0,
 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0,
 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0,
 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0,
 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1
 } ;

#define EVENT_SIZE_ 3539

int events_[EVENT_SIZE_] = {
 893, 894, 935, 747, 907, 851, 876, 859, 902, 895, 835, 909, 899, 884, 882, 880, 911, 751, 860, 900,
 727, 762, 765, 909, 937, 936, 855, 933, 872, 798, 821, 751, 936, 902, 911, 916, 820, 771, 901, 915,
 908, 902, 722, 797, 906, 876, 860, 880, 778, 878, 931, 780, 909, 937, 936, 855, 933, 872, 798, 821,
 751, 936, 902, 911, 916, 820, 771, 901, 915, 908, 902, 722, 797, 906, 876, 860, 880, 778, 878, 931,
 780, 710, 835, 876, 852, 924, 884, 895, 736, 891, 785, 736, 911, 891, 849, 773, 746, 899, 874, 745,
 898, 884, 787, 887, 918, 711, 893, 751, 901, 814, 847, 914, 884, 857, 710, 835, 876, 852, 924, 884,
 895, 736, 891, 785, 736, 911, 891, 849, 773, 746, 899, 874, 745, 898, 884, 787, 887, 918, 711, 893,
 751, 901, 814, 847, 914, 884, 857, 920, 887, 942, 876, 915, 923, 760, 876, 921, 930, 835, 745, 901,
 911, 861, 906, 867, 940, 878, 846, 765, 778, 829, 844, 783, 829, 918, 745, 871, 730, 928, 920, 887,
 942, 876, 915, 923, 760, 876, 921, 930, 835, 745, 901, 911, 861, 906, 867, 940, 878, 846, 765, 778,
 829, 844, 783, 829, 918, 745, 871, 730, 928, 912, 887, 890, 797, 814, 899, 801, 830, 773, 866, 874,
 816, 815, 892, 861, 759, 717, 780, 881, 860, 926, 859, 829, 912, 887, 890, 797, 814, 899, 801, 830,
 773, 866, 874, 816, 815, 892, 861, 759, 717, 780, 881, 860, 926, 859, 829, 782, 883, 892, 753, 887,
 896, 900, 877, 800, 928, 907, 759, 838, 917, 789, 815, 775, 898, 902, 920, 879, 893, 878, 890, 774,
 937, 916, 939, 782, 883, 892, 753, 887, 896, 900, 877, 800, 928, 907, 759, 838, 917, 789, 815, 775,
 898, 902, 920, 879, 893, 878, 890, 774, 937, 916, 939, 931, 849, 829, 801, 844, 862, 716, 768, 754,
 901, 902, 924, 811, 907, 905, 763, 853, 883, 859, 786, 885, 911, 883, 890, 714, 875, 915, 769, 933,
 931, 849, 829, 801, 844, 862, 716, 768, 754, 901, 902, 924, 811, 907, 905, 763, 853, 883, 859, 786,
 885, 911, 883, 890, 714, 875, 915, 769, 933, 798, 854, 910, 761, 711, 905, 718, 801, 876, 922, 930,
 771, 772, 716, 787, 733, 891, 907, 876, 772, 763, 745, 914, 919, 716, 798, 854, 910, 761, 711, 905,
 718, 801, 876, 922, 930, 771, 772, 716, 787, 733, 891, 907, 876, 772, 763, 745, 914, 919, 716, 807,
 828, 885, 870, 814, 715, 758, 744, 923, 855, 899, 893, 842, 910, 901, 757, 829, 757, 829, 730, 734,
 893, 920, 820, 860, 899, 729, 792, 880, 939, 802, 807, 828, 885, 870, 814, 715, 758, 744, 923, 855,
 899, 893, 842, 910, 901, 757, 829, 757, 829, 730, 734, 893, 920, 820, 860, 899, 729, 792, 880, 939,
 802, 925, 883, 776, 863, 738, 876, 809, 794, 891, 761, 822, 935, 896, 848, 728, 889, 802, 898, 772,
 851, 927, 839, 876, 889, 942, 763, 790, 889, 928, 920, 778, 925, 883, 776, 863, 738, 876, 809, 794,
 891, 761, 822, 935, 896, 848, 728, 889, 802, 898, 772, 851, 927, 839, 876, 889, 942, 763, 790, 889,
 928, 920, 778, 823, 895, 785, 941, 733, 721, 920, 802, 893, 854, 794, 909, 871, 799, 866, 804, 883,
 939, 895, 875, 712, 826, 832, 712, 910, 772, 823, 831, 942, 880, 848, 913, 902, 860, 823, 895, 785,
 941, 733, 721, 920, 802, 893, 854, 794, 909, 871, 799, 866, 804, 883, 939, 895, 875, 712, 826, 832,
 712, 910, 772, 823, 831, 942, 880, 848, 913, 902, 860, 747, 870, 907, 832, 935, 771, 810, 915, 743,
 901, 923, 748, 817, 825, 889, 867, 720, 746, 906, 920, 893, 909, 886, 817, 851, 808, 931, 879, 752,
 930, 922, 711, 790, 901, 733, 866, 866, 879, 864, 937, 747, 870, 907, 832, 935, 771, 810, 915, 743,
 901, 923, 748, 817, 825, 889, 867, 720, 746, 906, 920, 893, 909, 886, 817, 851, 808, 931, 879, 752,
 930, 922, 711, 790, 901, 733, 866, 866, 879, 864, 937, 765, 887, 925, 907, 717, 721, 871, 766, 731,
 711, 718, 907, 919, 766, 887, 742, 705, 911, 729, 873, 724, 860, 746, 736, 920, 923, 722, 933, 894,
 765, 887, 925, 907, 717, 721, 871, 766, 731, 711, 718, 907, 919, 766, 887, 742, 705, 911, 729, 873,
 724, 860, 746, 736, 920, 923, 722, 933, 894, 889, 707, 780, 935, 706, 799, 709, 793, 775, 856, 922,
 813, 808, 849, 765, 747, 860, 942, 909, 759, 760, 942, 858, 789, 774, 705, 848, 874, 852, 879, 707,
 703, 718, 788, 889, 707, 780, 935, 706, 799, 709, 793, 775, 856, 922, 813, 808, 849, 765, 747, 860,
 942, 909, 759, 760, 942, 858, 789, 774, 705, 848, 874, 852, 879, 707, 703, 718, 788, 704, 859, 942,
 776, 789, 895, 819, 700, 759, 724, 803, 860, 875, 761, 753, 893, 738, 876, 919, 901, 832, 907, 924,
 780, 843, 840, 704, 859, 942, 776, 789, 895, 819, 700, 759, 724, 803, 860, 875, 761, 753, 893, 738,
 876, 919, 901, 832, 907, 924, 780, 843, 840, 859, 802, 794, 862, 748, 701, 835, 828, 886, 733, 877,
 719, 902, 900, 739, 919, 864, 915, 883, 712, 901, 747, 718, 866, 769, 825, 817, 938, 773, 859, 802,
 794, 862, 748, 701, 835, 828, 886, 733, 877, 719, 902, 900, 739, 919, 864, 915, 883, 712, 901, 747,
 718, 866, 769, 825, 817, 938, 773, 855, 737, 807, 747, 808, 781, 813, 741, 699, 762, 771, 887, 939,
 880, 750, 832, 821, 726, 897, 816, 775, 885, 742, 934, 698, 735, 898, 906, 830, 867, 901, 797, 789,
 791, 770, 865, 855, 737, 807, 747, 808, 781, 813, 741, 699, 762, 771, 887, 939, 880, 750, 832, 821,
 726, 897, 816, 775, 885, 742, 934, 698, 735, 898, 906, 830, 867, 901, 797, 789, 791, 770, 865, 856,
 881, 727, 887, 751, 898, 901, 885, 884, 900, 834, 925, 706, 742, 722, 781, 774, 763, 693, 898, 941,
 756, 939, 911, 769, 736, 728, 890, 845, 759, 777, 707, 875, 750, 904, 829, 856, 881, 727, 887, 751,
 898, 901, 885, 884, 900, 834, 925, 706, 742, 722, 781, 774, 763, 693, 898, 941, 756, 939, 911, 769,
 736, 728, 890, 845, 759, 777, 707, 875, 750, 904, 829, 833, 721, 721, 855, 855, 871, 861, 808, 720,
 705, 816, 923, 694, 886, 720, 901, 798, 819, 757, 750, 695, 730, 728, 752, 701, 737, 772, 754, 812,
 801, 710, 745, 919, 754, 746, 914, 716, 756, 833, 721, 721, 855, 855, 871, 861, 808, 720, 705, 816,
 923, 694, 886, 720, 901, 798, 819, 757, 750, 695, 730, 728, 752, 701, 737, 772, 754, 812, 801, 710,
 745, 919, 754, 746, 914, 716, 756, 886, 737, 920, 915, 802, 700, 910, 883, 879, 707, 920, 916, 905,
 729, 763, 939, 715, 803, 846, 786, 873, 804, 879, 766, 828, 930, 830, 822, 715, 829, 883, 723, 772,
 874, 899, 851, 714, 722, 911, 873, 916, 703, 763, 781, 879, 795, 886, 737, 920, 915, 802, 700, 910,
 883, 879, 707, 920, 916, 905, 729, 763, 939, 715, 803, 846, 786, 873, 804, 879, 766, 828, 930, 830,
 822, 715, 829, 883, 723, 772, 874, 899, 851, 714, 722, 911, 873, 916, 703, 763, 781, 879, 795, 758,
 883, 732, 710, 697, 907, 767, 704, 849, 767, 866, 712, 881, 863, 791, 890, 696, 714, 719, 730, 713,
 765, 896, 809, 764, 920, 901, 694, 939, 729, 875, 764, 940, 830, 856, 853, 910, 919, 921, 758, 883,
 732, 710, 697, 907, 767, 704, 849, 767, 866, 712, 881, 863, 791, 890, 696, 714, 719, 730, 713, 765,
 896, 809, 764, 920, 901, 694, 939, 729, 875, 764, 940, 830, 856, 853, 910, 919, 921, 700, 699, 942,
 716, 915, 840, 703, 717, 698, 853, 860, 818, 695, 937, 832, 906, 730, 709, 701, 901, 815, 845, 765,
 740, 776, 710, 711, 699, 902, 791, 822, 791, 760, 809, 745, 889, 812, 800, 855, 704, 939, 700, 699,
 942, 716, 915, 840, 703, 717, 698, 853, 860, 818, 695, 937, 832, 906, 730, 709, 701, 901, 815, 845,
 765, 740, 776, 710, 711, 699, 902, 791, 822, 791, 760, 809, 745, 889, 812, 800, 855, 704, 939, 722,
 763, 915, 795, 920, 745, 835, 718, 920, 915, 696, 803, 754, 871, 697, 930, 802, 914, 847, 849, 692,
 764, 699, 921, 898, 765, 883, 757, 817, 775, 849, 868, 741, 722, 763, 915, 795, 920, 745, 835, 718,
 920, 915, 696, 803, 754, 871, 697, 930, 802, 914, 847, 849, 692, 764, 699, 921, 898, 765, 883, 757,
 817, 775, 849, 868, 741, 717, 807, 704, 804, 920, 728, 882, 770, 737, 833, 867, 833, 902, 907, 809,
 692, 802, 921, 860, 732, 935, 756, 736, 830, 726, 935, 912, 938, 830, 799, 761, 817, 797, 723, 879,
 887, 717, 807, 704, 804, 920, 728, 882, 770, 737, 833, 867, 833, 902, 907, 809, 692, 802, 921, 860,
 732, 935, 756, 736, 830, 726, 935, 912, 938, 830, 799, 761, 817, 797, 723, 879, 887, 921, 898, 807,
 742, 818, 695, 902, 862, 887, 879, 825, 845, 803, 797, 854, 923, 698, 848, 794, 713, 852, 770, 777,
 802, 824, 714, 883, 768, 868, 941, 923, 898, 921, 898, 807, 742, 818, 695, 902, 862, 887, 879, 825,
 845, 803, 797, 854, 923, 698, 848, 794, 713, 852, 770, 777, 802, 824, 714, 883, 768, 868, 941, 923,
 898, 910, 752, 808, 856, 716, 825, 736, 833, 923, 886, 871, 849, 768, 899, 814, 883, 694, 838, 794,
 754, 887, 768, 812, 728, 763, 763, 893, 853, 868, 755, 777, 844, 939, 817, 834, 702, 879, 747, 710,
 758, 768, 871, 825, 885, 757, 921, 802, 910, 752, 808, 856, 716, 825, 736, 833, 923, 886, 871, 849,
 768, 899, 814, 883, 694, 838, 794, 754, 887, 768, 812, 728, 763, 763, 893, 853, 868, 755, 777, 844,
 939, 817, 834, 702, 879, 747, 710, 758, 768, 871, 825, 885, 757, 921, 802, 764, 941, 799, 804, 726,
 765, 807, 839, 912, 782, 895, 745, 923, 742, 698, 755, 894, 879, 776, 911, 935, 817, 876, 693, 705,
 726, 776, 740, 763, 818, 720, 733, 860, 748, 936, 777, 848, 698, 764, 941, 799, 804, 726, 765, 807,
 839, 912, 782, 895, 745, 923, 742, 698, 755, 894, 879, 776, 911, 935, 817, 876, 693, 705, 726, 776,
 740, 763, 818, 720, 733, 860, 748, 936, 777, 848, 698, 709, 879, 880, 803, 902, 916, 857, 730, 875,
 879, 939, 774, 880, 837, 916, 915, 719, 931, 849, 876, 754, 763, 911, 737, 799, 774, 939, 742, 818,
 875, 697, 730, 703, 880, 802, 729, 883, 912, 940, 723, 709, 879, 880, 803, 902, 916, 857, 730, 875,
 879, 939, 774, 880, 837, 916, 915, 719, 931, 849, 876, 754, 763, 911, 737, 799, 774, 939, 742, 818,
 875, 697, 730, 703, 880, 802, 729, 883, 912, 940, 723, 906, 870, 887, 733, 722, 868, 906, 906, 895,
 697, 767, 745, 756, 784, 850, 802, 853, 698, 745, 804, 748, 887, 854, 826, 720, 890, 875, 876, 697,
 911, 927, 836, 730, 906, 870, 887, 733, 722, 868, 906, 906, 895, 697, 767, 745, 756, 784, 850, 802,
 853, 698, 745, 804, 748, 887, 854, 826, 720, 890, 875, 876, 697, 911, 927, 836, 730, 908, 815, 857,
 716, 793, 892, 748, 741, 699, 781, 785, 698, 911, 830, 783, 730, 867, 764, 715, 817, 729, 767, 742,
 931, 852, 822, 819, 760, 764, 734, 908, 815, 857, 716, 793, 892, 748, 741, 699, 781, 785, 698, 911,
 830, 783, 730, 867, 764, 715, 817, 729, 767, 742, 931, 852, 822, 819, 760, 764, 734, 793, 847, 832,
 743, 738, 774, 712, 698, 793, 819, 754, 800, 811, 910, 899, 931, 868, 884, 832, 898, 876, 718, 894,
 791, 834, 887, 792, 805, 778, 766, 898, 857, 763, 774, 703, 806, 753, 790, 793, 847, 832, 743, 738,
 774, 712, 698, 793, 819, 754, 800, 811, 910, 899, 931, 868, 884, 832, 898, 876, 718, 894, 791, 834,
 887, 792, 805, 778, 766, 898, 857, 763, 774, 703, 806, 753, 790, 816, 742, 925, 853, 885, 894, 745,
 911, 803, 922, 876, 917, 703, 936, 755, 750, 695, 883, 765, 717, 819, 764, 810, 757, 742, 796, 741,
 746, 820, 911, 750, 783, 885, 848, 874, 734, 825, 723, 816, 742, 925, 853, 885, 894, 745, 911, 803,
 922, 876, 917, 703, 936, 755, 750, 695, 883, 765, 717, 819, 764, 810, 757, 742, 796, 741, 746, 820,
 911, 750, 783, 885, 848, 874, 734, 825, 723, 793, 767, 751, 767, 848, 699, 793, 857, 817, 815, 725,
 725, 734, 872, 902, 756, 784, 940, 757, 868, 872, 756, 865, 867, 730, 924, 736, 817, 872, 695, 865,
 892, 738, 866, 793, 767, 751, 767, 848, 699, 793, 857, 817, 815, 725, 725, 734, 872, 902, 756, 784,
 940, 757, 868, 872, 756, 865, 867, 730, 924, 736, 817, 872, 695, 865, 892, 738, 866, 901, 893, 764,
 885, 867, 715, 723, 874, 724, 818, 808, 786, 801, 805, 884, 887, 803, 854, 793, 779, 819, 768, 816,
 937, 900, 819, 899, 769, 767, 717, 842, 752, 912, 873, 901, 893, 764, 885, 867, 715, 723, 874, 724,
 818, 808, 786, 801, 805, 884, 887, 803, 854, 793, 779, 819, 768, 816, 937, 900, 819, 899, 769, 767,
 717, 842, 752, 912, 873, 717, 766, 743, 880, 903, 912, 759, 722, 734, 769, 766, 928, 883, 766, 894,
 903, 790, 911, 814, 831, 714, 861, 895, 861, 783, 746, 800, 719, 937, 840, 803, 887, 710, 717, 766,
 743, 880, 903, 912, 759, 722, 734, 769, 766, 928, 883, 766, 894, 903, 790, 911, 814, 831, 714, 861,
 895, 861, 783, 746, 800, 719, 937, 840, 803, 887, 710, 764, 821, 860, 740, 893, 734, 805, 758, 925,
 851, 743, 907, 903, 859, 873, 881, 749, 777, 804, 756, 693, 734, 795, 757, 785, 710, 871, 873, 885,
 895, 858, 924, 864, 911, 904, 766, 790, 719, 764, 821, 860, 740, 893, 734, 805, 758, 925, 851, 743,
 907, 903, 859, 873, 881, 749, 777, 804, 756, 693, 734, 795, 757, 785, 710, 871, 873, 885, 895, 858,
 924, 864, 911, 904, 766, 790, 719, 833, 712, 743, 917, 879, 800, 724, 775, 889, 851, 712, 842, 881,
 826, 767, 883, 784, 912, 756, 757, 805, 693, 753, 873, 909, 754, 884, 766, 752, 780, 793, 935, 845,
 939, 780, 908, 941, 701, 920, 927, 827, 833, 712, 743, 917, 879, 800, 724, 775, 889, 851, 712, 842,
 881, 826, 767, 883, 784, 912, 756, 757, 805, 693, 753, 873, 909, 754, 884, 766, 752, 780, 793, 935,
 845, 939, 780, 908, 941, 701, 920, 927, 827, 881, 877, 803, 901, 704, 909, 877, 755, 768, 895, 695,
 727, 895, 812, 929, 935, 806, 900, 805, 890, 717, 862, 922, 766, 905, 876, 810, 754, 794, 917, 727,
 836, 871, 706, 756, 758, 850, 881, 877, 803, 901, 704, 909, 877, 755, 768, 895, 695, 727, 895, 812,
 929, 935, 806, 900, 805, 890, 717, 862, 922, 766, 905, 876, 810, 754, 794, 917, 727, 836, 871, 706,
 756, 758, 850, 917, 765, 765, 841, 835, 858, 894, 765, 879, 801, 930, 868, 925, 904, 913, 791, 929,
 766, 932, 769, 820, 836, 897, 851, 765, 909, 851, 749, 806, 718, 862, 873, 824, 699, 917, 765, 765,
 841, 835, 858, 894, 765, 879, 801, 930, 868, 925, 904, 913, 791, 929, 766, 932, 769, 820, 836, 897,
 851, 765, 909, 851, 749, 806, 718, 862, 873, 824, 699, 728, 863, 707, 862, 780, 794, 823, 820, 743,
 802, 745, 694, 895, 927, 891, 904, 912, 881, 804, 770, 885, 896, 770, 725, 770, 777, 693, 754, 883,
 885, 806, 926, 735, 817, 759, 839, 728, 863, 707, 862, 780, 794, 823, 820, 743, 802, 745, 694, 895,
 927, 891, 904, 912, 881, 804, 770, 885, 896, 770, 725, 770, 777, 693, 754, 883, 885, 806, 926, 735,
 817, 759, 839, 900, 887, 938, 780, 809, 909, 754, 820, 814, 941, 902, 729, 715, 825, 757, 766, 748,
 746, 777, 843, 759, 881, 852, 757, 763, 739, 862, 904, 769, 922, 851, 731, 758, 900, 699, 801, 901,
 757, 695, 917, 768, 719, 910, 900, 887, 938, 780, 809, 909, 754, 820, 814, 941, 902, 729, 715, 825,
 757, 766, 748, 746, 777, 843, 759, 881, 852, 757, 763, 739, 862, 904, 769, 922, 851, 731, 758, 900,
 699, 801, 901, 757, 695, 917, 768, 719, 910, 693, 874, 784, 746, 766, 784, 857, 767, 713, 750, 879,
 747, 942, 873, 886, 770, 901, 724, 831, 713, 700, 805, 820, 784, 705, 763, 851, 700, 886, 712, 835,
 768, 850, 829, 926, 928, 693, 874, 784, 746, 766, 784, 857, 767, 713, 750, 879, 747, 942, 873, 886,
 770, 901, 724, 831, 713, 700, 805, 820, 784, 705, 763, 851, 700, 886, 712, 835, 768, 850, 829, 926,
 928, 917, 765, 902, 925, 868, 835, 900, 887, 925, 917, 768, 889, 697, 796, 759, 855, 933, 835, 767,
 753, 849, 747, 775, 813, 761, 768, 889, 847, 767, 704, 918, 933, 869, 770, 786, 804, 805, 828, 862,
 917, 765, 902, 925, 868, 835, 900, 887, 925, 917, 768, 889, 697, 796, 759, 855, 933, 835, 767, 753,
 849, 747, 775, 813, 761, 768, 889, 847, 767, 704, 918, 933, 869, 770, 786, 804, 805, 828, 862, 901,
 693, 824, 773, 801, 879, 693, 862, 693, 770, 707, 825, 786, 765, 811, 862, 873, 895, 804, 930, 835,
 890, 753, 750, 728, 851, 827, 758, 806, 714, 704, 815, 694, 806, 770, 915, 742, 694, 789, 744, 733,
 901, 693, 824, 773, 801, 879, 693, 862, 693, 770, 707, 825, 786, 765, 811, 862, 873, 895, 804, 930,
 835, 890, 753, 750, 728, 851, 827, 758, 806, 714, 704, 815, 694, 806, 770, 915, 742, 694, 789, 744,
 733, 714, 771, 913, 877, 760, 856, 925, 735, 754, 862, 834, 820, 759, 805, 922, 886, 769, 924, 698,
 766, 913, 832, 759, 727, 848, 693, 925, 778, 716, 858, 693, 743, 902, 775, 868, 801, 770, 745, 894,
 784, 714, 771, 913, 877, 760, 856, 925, 735, 754, 862, 834, 820, 759, 805, 922, 886, 769, 924, 698,
 766, 913, 832, 759, 727, 848, 693, 925, 778, 716, 858, 693, 743, 902, 775, 868, 801, 770, 745, 894,
 784, 724, 919, 703, 739, 775, 763, 889, 750, 877, 769, 719, 918, 909, 766, 877, 883, 692, 693, 868,
 913, 767, 918, 833, 693, 900, 693, 769, 914, 765, 881, 933, 835, 869, 766, 900, 861, 797, 859, 793,
 728, 724, 919, 703, 739, 775, 763, 889, 750, 877, 769, 719, 918, 909, 766, 877, 883, 692, 693, 868,
 913, 767, 918, 833, 693, 900, 693, 769, 914, 765, 881, 933, 835, 869, 766, 900, 861, 797, 859, 793,
 728, 810, 803, 757, 927, 759, 766, 896, 868, 804, 829, 869, 735, 738, 922, 832, 886, 889, 793, 899,
 707, 758, 858, 743, 841, 708, 768, 705, 697, 769, 815, 768, 868, 843, 842, 858, 806, 693, 810, 803,
 757, 927, 759, 766, 896, 868, 804, 829, 869, 735, 738, 922, 832, 886, 889, 793, 899, 707, 758, 858,
 743, 841, 708, 768, 705, 697, 769, 815, 768, 868, 843, 842, 858, 806, 693, 813, 700, 784, 848, 925,
 818, 886, 922, 862, 768, 759, 806, 868, 851, 903, 925, 878, 908, 881, 882, 853, 814, 910, 767, 784,
 898, 715, 754, 766, 925, 931, 905, 859, 938, 861, 693, 898, 766, 834, 741, 894, 909, 728, 851, 784,
 765, 895, 813, 700, 784, 848, 925, 818, 886, 922, 862, 768, 759, 806, 868, 851, 903, 925, 878, 908,
 881, 882, 853, 814, 910, 767, 784, 898, 715, 754, 766, 925, 931, 905, 859, 938, 861, 693, 898, 766,
 834, 741, 894, 909, 728, 851, 784, 765, 895, 877, 805, 904, 773, 868, 863, 695, 936, 872, 878, 773,
 820, 697, 862, 743, 873, 846, 912, 693, 874, 735, 844, 789, 805, 941, 894, 828, 755, 782, 937, 877,
 805, 904, 773, 868, 863, 695, 936, 872, 878, 773, 820, 697, 862, 743, 873, 846, 912, 693, 874, 735,
 844, 789, 805, 941, 894, 828, 755, 782, 937, 700, 700, 868, 769, 803, 785, 810, 917, 772, 854, 831,
 693, 839, 829, 724, 887, 900, 933, 698, 865, 804, 862, 863, 927, 832, 877, 869, 873, 784, 766, 935,
 848, 930, 893, 729, 934, 699, 916, 929, 836, 855, 728, 808, 908, 891, 828, 700, 700, 868, 769, 803,
 785, 810, 917, 772, 854, 831, 693, 839, 829, 724, 887, 900, 933, 698, 865, 804, 862, 863, 927, 832,
 877, 869, 873, 784, 766, 935, 848, 930, 893, 729, 934, 699, 916, 929, 836, 855, 728, 808, 908, 891,
 828, 747, 919, 894, 860, 868, 942, 893, 917, 747, 881, 932, 804, 883, 884, 913, 923, 912, 749, 858,
 925, 825, 881, 846, 849, 866, 724, 875, 881, 750, 832, 727, 939, 841, 845, 709, 699, 899, 766
 } ;