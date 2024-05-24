# GNU General Public License v3.0
# Copyright 2024 Xin Huang
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, please see 
#
#    https://www.gnu.org/licenses/gpl-3.0.en.html


import matplotlib
import matplotlib.pyplot as plt
import numpy as np
matplotlib.use("Agg")

def make_plot(matrix_file, plot_file):
    data = []
    with open(matrix_file, 'r') as f:
        for line in f:
            data.append(line.rstrip().split(" "))

    data = np.array(data).astype('int64')
    proportions = data/data.sum(axis=1, keepdims=True)
    classes = ['no introgression', 'sech-to-sim', 'sim-to-sech']
    plt.matshow(proportions, cmap=plt.cm.Blues)
    for i in range(len(proportions)):
        for j in range(len(proportions[i])):
            c = proportions[j,i]
            plt.text(i, j, str(c), va='center', ha='center')
    plt.tick_params(axis='x', top=False, labeltop=False, bottom=True, labelbottom=True)
    plt.xticks(ticks=[0, 1, 2], labels=classes)
    plt.yticks(ticks=[0, 1, 2], labels=classes)
    plt.xlabel('Predicted class')
    plt.ylabel('True class')
    plt.savefig(plot_file, bbox_inches='tight')

make_plot(snakemake.input.original_model_matrix, snakemake.output.original_model_plot)
make_plot(snakemake.input.reproduced_model_matrix, snakemake.output.reproduced_model_plot)
