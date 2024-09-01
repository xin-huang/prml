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


rule download_training_data:
    input:
    output:
        training_data = "resources/training_data/big_sim.npz",
    shell:
        """
        wget -c https://conservancy.umn.edu/bitstreams/e4d4a24d-0ff1-422e-8605-00f12502d445/download
        mv download {output.training_data}
        """


rule download_test_data:
    input:
    output:
        test_data1 = "resources/test_data/mig12.test.msOut.gz",
        test_data2 = "resources/test_data/mig21.test.msOut.gz",
        test_data3 = "resources/test_data/noMig.test.msOut.gz",
        original_model = "resources/original_model/big.data.89.2.acc.mod",
        training_script = "resources/scripts/train.neural.net.introgression.CNN.PYTHON3.py",
        test_original_model_script = "resources/scripts/extract.test.data.and.get.original.model.confusion.matrix.py",
        test_reproduced_model_script = "resources/scripts/extract.test.data.and.get.reproduced.model.confusion.matrix.py"
    shell:
        """
        git clone https://github.com/flag0010/pop_gen_cnn/
        cp pop_gen_cnn/introgression/mig12.test.msOut.gz resources/test_data/
        cp pop_gen_cnn/introgression/mig21.test.msOut.gz resources/test_data/
        cp pop_gen_cnn/introgression/noMig.test.msOut.gz resources/test_data/
        cp pop_gen_cnn/introgression/big.data.89.2.acc.mod resources/original_model/
        sed s'%/dataset/big_sim.npz%resources/training_data/big_sim.npz%' pop_gen_cnn/introgression/train.neural.net.introgression.CNN.PYTHON3.py | sed s'%big.data.89.2.acc.mod%results/reproduced_model/big.data.89.2.acc.mod.keras%' | sed '9iimport tensorflow as tf' | sed '10ikeras.utils.set_random_seed(555)' | sed '11itf.config.experimental.enable_op_determinism()' > {output.training_script}
        sed s'%mig12.test.msOut.gz%resources/test_data/mig12.test.msOut.gz%' pop_gen_cnn/introgression/extract.test.data.and.get.final.model.confusion.matrix.py | sed s'%mig21.test.msOut.gz%resources/test_data/mig21.test.msOut.gz%' | sed s'%noMig.test.msOut.gz%resources/test_data/noMig.test.msOut.gz%' | sed s'%big.data.89.2.acc.mod%resources/original_model/big.data.89.2.acc.mod%' > {output.test_original_model_script}
        sed s'%mig12.test.msOut.gz%resources/test_data/mig12.test.msOut.gz%' pop_gen_cnn/introgression/extract.test.data.and.get.final.model.confusion.matrix.py | sed s'%mig21.test.msOut.gz%resources/test_data/mig21.test.msOut.gz%' | sed s'%noMig.test.msOut.gz%resources/test_data/noMig.test.msOut.gz%' | sed s'%big.data.89.2.acc.mod%results/reproduced_model/big.data.89.2.acc.mod.keras%' | sed s'/print \\(.*\\)/print(\\1)/' | sed s'/xrange/range/' > {output.test_reproduced_model_script}
        rm -rf pop_gen_cnn
        """
