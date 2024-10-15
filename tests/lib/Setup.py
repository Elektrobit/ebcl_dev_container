""" Prepare the container. """
import utils


class Setup:
    """ Start and stop the dev container. """
    
    def run_container(self):
        """ Start the dev container. """
        utils.run_container()
    
    def stop_container(self):
        """ Stop the dev container. """
        utils.stop_container()
