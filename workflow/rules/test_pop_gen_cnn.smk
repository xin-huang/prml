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


rule original_model_performance:
    input:
        test_data1 = rules.download_test_data.output.test_data1,
        test_data2 = rules.download_test_data.output.test_data2,
        test_data3 = rules.download_test_data.output.test_data3,
        original_model = rules.download_test_data.output.original_model,
        script = rules.download_test_data.output.test_original_model_script,
    output:
        performance = "results/performance/pop_gen_cnn.original.model.performance",
        confusion_matrix = "results/performance/pop_gen_cnn.original.model.confusion.matrix",
    conda: "../envs/py2env.yaml",
    shell:
        """
        python {input.script} > {output.performance}
        grep "\\[" {output.performance} | head -3 | sed 's/\\[//g' | sed 's/\\]//g' | awk '{{print $1,$2,$3}}' > {output.confusion_matrix}
        """


rule reproduced_model_performance:
    input:
        test_data1 = rules.download_test_data.output.test_data1,
        test_data2 = rules.download_test_data.output.test_data2,
        test_data3 = rules.download_test_data.output.test_data3,
        reproduced_model = rules.training.output.reproduced_model,
        script = rules.download_test_data.output.test_reproduced_model_script,
    output:
        performance = "results/performance/pop_gen_cnn.reproduced.model.performance",
        confusion_matrix = "results/performance/pop_gen_cnn.reproduced.model.confusion.matrix",
    shell:
        """
        python {input.script} > {output.performance}
        grep "\\[" {output.performance} | head -4 | tail -3 | sed 's/\\[//g' | sed 's/\\]//g' | awk '{{print $1,$2,$3}}' > {output.confusion_matrix}
        """


rule plot:
    input:
        original_model_matrix = rules.original_model_performance.output.confusion_matrix,
        reproduced_model_matrix = rules.reproduced_model_performance.output.confusion_matrix,
    output:
        original_model_plot = "results/plots/pop_gen_cnn.original.model.performance.png",
        reproduced_model_plot = "results/plots/pop_gen_cnn.reproduced.model.performance.png",
    script: 
        "../scripts/plot.py"
